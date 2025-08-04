{lib, pkgs, config, utils,...}: let
  inherit (lib)
    mkOption
    mapAttrs
    mapAttrs'
    nameValuePair
    filter
    splitString
    readFile
    genAttrs
    head
    tail
    reverseList
    hasInfix
    foldAttrs
    hasPrefix
    filterAttrs
    length
    hasSuffix
    hasAttr
    foldl'
    toUpper
    replaceStrings
    attrNames
    removePrefix
    attrValues
    substring
    mkEnableOption
    mkPackageOption
    getExe
    foldr
    mkForce
    concatMapAttrsStringSep
    any;
  inherit (builtins) 
    toString
    hashString;
  inherit (utils) escapeSystemdExecArgs;
  inherit (lib.cli) toGNUCommandLine;
  rg = getExe pkgs.ripgrep;
  cfg = config.rclone;
  rclone = getExe pkgs.rclone;
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
  options.rclone = with lib.types; {
    enable = mkEnableOption "rclone";
    package = mkPackageOption pkgs "rclone" {};
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
    mounts = mkOption {
      type = attrsOf (submodule {
        options = {
          user = mkOption { 
            type = nullOr str; 
            default = "root"; 
            description = "user name that will be passed to fusemount3 as `-o UserName=user123`";
          };
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
  config = lib.mkIf cfg.enable {
    programs.fuse = {
      userAllowOther = true;
      mountMax = 32000;
    };

    systemd.services = mapAttrs (path: val: with val; let
      pathID = substring 0 4 (hashString "sha256" path);
      linkedRemotes = foldl' 
        (acc: elem: let
          flagsSubstSecrets = remote: mapAttrs 
            (k: v: let
              getSecret = pkgs.writeScript "getSecret" ''
                ${pkgs.uutils-coreutils-noprefix}/bin/cat ${v}
              '';
            in
              if (substring 0 13 v) == "/run/secrets/"
                then "$(${getSecret})"
                else v
            ) 
            (filterAttrs 
              (k: v: v != null) 
              remote.flags
            );

          flagsSubstSecretsPrev = flagsSubstSecrets (head acc);

          flagsSubstSecretsCurrent = flagsSubstSecrets elem;

          getConStr = name:
            name
            + ","
            + (concatMapAttrsStringSep
                ","
                (flag: flagValue:
                  ''${flag}="${flagValue}"''
                )
                flagsSubstSecretsPrev
              )
            + ":";

          name = if (elem).name != null
            then (elem).name
            else "remote${toString (length acc)}" + pathID;

          prevRemoteName = if null != (head acc).name
            then (head acc).name
            else "remote${toString ((length acc) - 1)}" + pathID;

        in acc ++ [{
          inherit name;
          inherit (elem) type;
          conStr = getConStr name;
          flags = (filterAttrs
            (k: v: hasPrefix 
              elem.type 
              k
            ) 
            (mapAttrs
              (k: v: let
              in if hasSuffix "remote" k
                then getConStr prevRemoteName
                else v
              ) 
              flagsSubstSecretsCurrent
            )
          );
        }])
        [] 
        (reverseList val.remotes);

      topRemoteName = (head (reverseList linkedRemotes)).name;
      topRemoteConStr = (head (reverseList linkedRemotes)).conStr;
      allRemoteFlags = foldl' 
        (acc: remote: acc // mapAttrs'
          (flagName: flagValue:
            nameValuePair
              ("RCLONE_CONFIG_"
                + toUpper remote.name
                + "_"
                + toUpper 
                  (replaceStrings
                    ["-"]
                    ["_"]
                    (removePrefix "${remote.type}-" flagName)
                  )
              )
              flagValue
          ) 
          remote.flags
        ) 
        {} 
        linkedRemotes;
      unitName = "rclone-mount-${topRemoteName}-${pathID}.service";
      mountScript = 
        ((concatMapAttrsStringSep
          "\n"
          (k: v: "local ${k}=${v}")
          allRemoteFlags
        )
        + concatMapAttrsStringSep 
          "\n" 
          (k: v: 
            "local RCLONE_" 
              + toUpper (replaceStrings
                ["-"]
                ["_"]
                k
              ) 
              + "=${v}"
          )
          ({
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
            vfs-read-chunk-streams = "16"; # number of concurrent read ahead chunk downloads
            vfs-refresh = "true"; # refresh the directory cache recursively on mount
            links = "true"; # enable support for symlinks
            vfs-links = "true"; # enable support for symlinks in the VFS caching layer
            transfers = "4"; # the number of concurrent file uploads from cache
            #vfs-used-is-size = true; # may be very expensive 
                                      # due to excessive API calls for rclone size in S3 backends
            vfs-write-back = "1s"; # time to write back files from cache after they have been used
            write-back-cache = "true";  # makes kernel buffer writes before sending them to rclone. 
                                      # without this, writethrough caching is used
            allow-non-empty = "true"; # allow mounting over a non-empty directory
            #allow-other = "false"; # dont allow other users to see this mount
            async-read = "true"; # use asyncronous reads
            attr-timeout = "1s";  # cache file attributes for 1 second in the kernel 
                                  # to avoid excessive callbacks to rclone
            default-permissions = "true"; # make kernel enforce access control using the file mode
            dir-cache-time = "5m0s"; # time to cache directories for
            poll-interval = "5s"; # time to wait between polling for changes
                                  # must be smaller than dir-cache-time
            s3-directory-markers = "true";
            syslog = "true";
            config = "/dev/null";
            fuse-flag = "'-o UserName=${val.user}'";
          } // filterAttrs 
            (k: v: v != null) 
            val.flags
          )
        + ''
          ${getExe cfg.package} mount ${topRemoteConStr} ${path} -vv
        ''
      );
    in {
      name = mkForce unitName;
      script = mountScript;
      wants = ["networking.target"];
      wantedBy = ["multi-user.target"];
      unitConfig.Type = "notify";
      serviceConfig = { 
        Restart = "on-failure";
        RestartSec = "10s";
        #StartLimitBurst = 1;
        #StartLimitIntervalSec = "10s";
      };
    }) cfg.mounts;
  };
}
