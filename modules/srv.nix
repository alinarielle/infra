{
  opt,
  cfg,
  lib,
  config,
  ...
}:
{
  opt.services =
    with lib.types;
    lib.mkOption {
      default = { };
      type = (
        submodule {
          options = {
            script = lib.mkOption {
              type = nullOr lines;
              default = null;
            };
            exec = lib.mkOption {
              type = nullOr list;
              default = null;
            };
            persist = lib.mkOption {
              type = bool;
              default = true;
            };
            dataDir = lib.mkOption {
              type = nullOr path;
              default = null;
            };
            net = {
              intranet = lib.mkOption {
                type = bool;
                default = false;
              };
              clearnet = lib.mkOption {
                type = bool;
                default = false;
              };
              dns = {
                enable = lib.mkEnableOption "DNS with sane defaults";
                sub = lib.mkOption {
                  type = nullOr str;
                  default = null;
                };
                domain = lib.mkOption {
                  type = nullOr str;
                  default = null;
                };
                fqdn = lib.mkOption {
                  type = nullOr str;
                  default = null;
                };
              };
              ports = lib.mkOption {
                type = listOf port;
                default = [ ];
              };
            };
            paths = {
              ro = lib.mkOption {
                type = listOf path;
                default = [ ];
              };
              rw = lib.mkOption {
                type = listOf path;
                default = [ ];
              };
              exec = lib.mkOption {
                type = listOf path;
                default = [ ];
              };
            };
          };
        }
      );
    };
  config = {
    l.tasks.tasks = lib.mapAttrs (key: val: {
      user = lib.mkIf val.persist key;
      group = lib.mkIf val.persist key;
      net = lib.mkIf (val.net.intranet || val.net.clearnet) true;
      inherit (val)
        paths
        persist
        dataDir
        script
        exec
        ;
    }) cfg.services;

    assertions = lib.mapAttrsToList (
      key: val:
      {
        assertion = val.script != null;
        message = "the script of service ${key} cannot be undefined";
      }
        {
          assertion = val.paths.exec != [ ];
          message = "define at least one executable path for service ${key}";
        }
        (
          lib.mkIf config.l.storage.filesystem.noexecMount.enable {
            assertion = (builtins.all (x: (builtins.substring 0 11 x) == "/nix/store/") val.paths.exec);
            message = ''
              all partitions except the nix store are mounted as noexec, executable paths
              	must start with /nix/store'';
          }
        )
    ) cfg.services;
  };
}
#TODO DNS, reverse proxy, ACME
