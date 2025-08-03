{lib, pkgs, config, ...}: let
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
    attrValues
    substring
    hashString;
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
        "${rclone} mount | ${rg} -e "--" | head -n -1 | tail -n 77  > rclone-mount-flags.txt";
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
          flags = parseFlags ./rclone-mount-flags.txt;
          remotes = mkOption {
            type = listOf (submodule {
              options = {
                flags = parseFlags ./rclone-remote-flags.txt;
                name = mkOption { type = nullOr str; default = null; };
                type = mkOption {
                  type = enum (map 
                    (x: head (splitString 
                      "-" 
                      x)
                    ) 
                    (attrNames (parseFlags ./rclone-remote-flags.txt))
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
    programs.fuse.userAllowOther = true;

    systemd.tmpfiles.settings."vfsCache".${cfg.cacheDir}.d = {
      user = "root"; group = "root"; type = "d"; age = "-"; mode = "0755";
    };

    tasks = mapAttrs (path: val: with val; let
      pathID = substring 0 4 (hashString "sha256" path);
      linkedRemotes = foldr 
        (acc: elem: acc ++ [{
          inherit (elem) type;
          name = if (elem).name != null
            then (elem).name
            else "remote${length acc}" + pathID;
          flags = (filterAttrs
            (k: v: hasPrefix 
              elem.type 
              k
            ) 
            (mapAttrs 
              (k: v: if hasSuffix "remote" k
                then if null == (head acc)
                  then (head acc).name
                  else "remote${(length acc) - 1}" + pathID
                else v
              ) 
              elem.flags
            )
          );
        }])
        [] 
        (val.remotes);
    in {
      unix = { 
        inherit user;
        group = user;
      };

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
          ({
            cache-dir = cfg.cacheDir; # use this directory as VFS cache
            vfs-cache-mode = "full"; # cache everything
            vfs-cache-max-age = "off"; # dont remove stale objects from cache
            vfs-cache-min-free-space = "25G";  # make sure there is still 25GB of storage available 
                                                # on the disk used for caching
            vfs-cache-poll-interval = "5s"; # poll for new files every 5 seconds
            vfs-fast-fingerprint = "true";  # dont query slow file metadata for faster syncs,
                                          # is less accurate
            #vfs-read-ahead = ""; # extra read ahead over --buffer-size when using cache-mode full
            vfs-read-chunk-size = "4M"; # size of read-ahead chunks
            vfs-read-chunk-size-limit = "off";  # if greater than --vfs-read-chunk-size, 
                                                # double the chunk size after each chunk read, 
                                                # until the limit is reached ('off' is unlimited)
            vfs-read-chunk-streams = 16; # number of concurrent read ahead chunk downloads
            vfs-refresh = "true"; # refresh the directory cache recursively on mount
            links = "true"; # enable support for symlinks
            vfs-links = "true"; # enable support for symlinks in the VFS caching layer
            transfers = 4; # the number of concurrent file uploads from cache
            #vfs-used-is-size = true; # may be very expensive 
                                      # due to excessive API calls for rclone size in S3 backends
            vfs-write-back = "1s"; # time to write back files from cache after they have been used
            write-back-cache = "true";  # makes kernel buffer writes before sending them to rclone. 
                                      # without this, writethrough caching is used
            allow-non-empty = "true"; # allow mounting over a non-empty directory
            allow-root = "true"; # allow access to root user
            allow-other = "false"; # dont allow other users to see this mount
            async-read = "true"; # use asyncronous reads
            attr-timeout = "1s";  # cache file attributes for 1 second in the kernel 
                                  # to avoid excessive callbacks to rclone
            default-permissions = "true"; # make kernel enforce access control using the file mode
            dir-cache-time = "5m0s"; # time to cache directories for
            poll-interval = "5s"; # time to wait between polling for changes
                                  # must be smaller than dir-cache-time
          } // filterAttrs 
            (k: v: v != null) 
            val.flags
          )
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
          ({
            s3-directory-markers = "true";
          } // filterAttrs 
            (k: v: v != null) 
            elem.flags
          )
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
