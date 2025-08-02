{lib, pkgs, ...}: let
  inherit (lib)
    mkOption
    mapAttrs
    filter
    splitString
    readFile
    genAttrs
    head
    tail
    reverseList
    hasInfix
    imap
    foldAttrs
    hasPrefix
    filterAttrs
    length
    hasSuffix
    hasAttr
    fold'
    toUpper
    replaceStrings
    toString
    attrNames
    removePrefix
    attrValues;
  inherit (lib.cli) toGNUCommandLine;
  rclone = lib.getExe pkgs.rclone;
  rg = lib.getExe pkgs.ripgrep;
  cfg = config.multi-homed;
  parseFlags = file:  mapAttrs 
    (key: val: with lib.types; mkOption { 
      description = val; 
      type = nullOr (oneOf [str package path]);
      default = null;
    }) 
    (let 
      flagsVerbose = filter 
        (x: x != "") 
        (splitString 
          "\n" 
          (readFile file)
        ); 
    in genAttrs 
      (map 
        (x: head 
          (splitString 
            " " 
            (head 
              (tail 
                (splitString 
                  "--" 
                  x
                )
              )
            )
          )
        ) 
      flagsVerbose) 
      (flag: head 
        (reverseList 
          (splitString 
            "   "
            (head 
              (filter 
                (x: hasInfix 
                  flag 
                  x
                ) 
                flagsVerbose
              )
            )
          )
        )
      )
    );
in {
  options.multi-homed = with lib.types; {
    updateRemoteFlags = mkOption { 
      type = package; 
      default = pkgs.writeShellScript 
        "update rclone remote flags"
        "${rclone} help flags | ${rg} -e "--" | head -n -2 > rclone-remote-flags.txt";
    };
    updateMountFlags = mkOption { 
      type = package; 
      default = pkgs.writeShellScript 
        "update rclone mount flags"
        "${rclone} mount | ${rg} -e "--" | head -n -2 > rclone-mount-flags.txt";
    };
    cacheDir = lib.mkOption {
      type = nullOr path;
      default = "/persist/cache/rclone";
      description = ''
        the directory to use as VFS cache, will be created using systemd.tmpfiles.settings.
        make sure to put this on a fast storage disk on which you want to cache your files.
        set to null to not cache any files (not recommended)
      '';
    };
    mounts = mkOption {
      type = attrsOf (submodule {
        options = {
          user = mkOption { type = nullOr str; default = null; };
          flags = parseFlags ./rclone-mount-flags;
          remotes = mkOption {
            type = listOf (submodule {
              options = {
                flags = parseFlags ./rclone-remote-flags;
                name = mkOption { type = nullOr str; default = null; };
                type = mkOption {
                  type = enum (map 
                    (x: head (splitString 
                      "-" 
                      x)
                    ) 
                    (attrNames (parseFlags ./rclone-remote-flags))
                  );
                };
              };
            });
          };
        };
      });
    };
  };
  imports = [ ./tasks.nix ];
  config = {
    programsfuse.userAllowOther = true;

    systemd.tmpfiles.settings."vfsCache".${cfg.cacheDir}.d = {
      user = "root"; group = "root"; type = "d"; age = "-"; mode = "0755";
    };

    tasks = mapAttrs (path: val: with val; let
      linkedRemotes = foldr 
        (acc: elem: acc ++ [{
          inherit (elem) type;
          name = if (elem).name != null
            then (elem).name
            else "remote${length acc}";
          flags = (filterAttrs
            (k: v: hasPrefix 
              elem.type 
              k
            ) 
            (mapAttrs 
              (k: v: if hasSuffix "remote" k
                then if null == (head acc)
                  then (head acc).name
                  else "remote${(length acc) - 1}"
                else v
              ) 
              elem.flags
            )
          );
        }])
        [] 
        (val.remotes);
    in {
      inherit user;
      group = user;
      environment = (fold'
        (acc: elem: acc // mapAttrs' 
          (name: value: nameValuePair
            ("RCLONE_" + toUpper (replaceStrings
              ["-"]
              ["_"]
              name
            ))
            (value)
          ) 
          val.flags 
        // mapAttrs' 
          (name: value: nameValuePair 
            ("RCLONE_CONFIG_${toUpper elem.name}_" + toUpper (replaceStrings 
              ["-"] 
              ["_"] 
              name
            ))
            (if hasPrefix "/run/secrets/" value 
              then "%d/" + removePrefix "/run/secrets/"
              else value
            )
          ) 
          elem.flags
        ) 
        {}
        linkedRemotes);
      exec = [ 
        rclone 
        "mount" 
        "${(head linkedRemotes).name}:"
        key 
      ];
      extraConfig.serviceConfig.LoadCredential = fold'
        (acc: elem: acc ++ map
          (x: (removePrefix "/run/secrets/" x) + ":" + x)
          (filter 
            (x: hasPrefix "/run/secrets/" x) 
            (attrValues elem.flags))
        ) 
        [] 
        linkedRemotes;
    }) cfg.mounts;
  };
}
