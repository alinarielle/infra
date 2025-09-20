{
  inputs,
  opt,
  cfg,
  lib,
  ...
}:
{
  imports = [ inputs.disko.nixosModules.disko ];
  opt = with lib.types; {
    disk = lib.mkOption {
      type = nullOr str;
      default = null;
    };
  };
  assertions = [
    {
      assertion = cfg.disk != null;
      message = "option ${cfg}.disk must be set!";
    }
  ];
  boot.loader.grub.device = cfg.disk;
  l.boot.systemd-boot.enable = lib.mkForce false;
  disko.devices.disk.${cfg.disk} = {
    device = cfg.disk;
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          type = "EF02";
          size = "1024M";
        };
        ESP = {
          type = "EF00";
          size = "1024M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
      };
    };
  };
}
