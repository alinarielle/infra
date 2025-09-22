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
  boot.loader.grub.device = "/dev/sda";
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
          priority = 1;
          type = "EF00";
          size = "1024M";
          content = {
            format = "vfat";
            type = "filesystem";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        main = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ]; # override existing partition
            subvolumes = {
              "/persist" = {
                mountpoint = "/persist";
              };
              "/nix" = {
                mountpoint = "/nix";
                mountOptions = [ "noatime" ];
              };
              "/home" = {
                mountOptions = [ "compress=zstd" ];
                mountpoint = "/home";
              };
            };
          };
        };
      };
    };
  };
  fileSystems."/persist".neededForBoot = true;
  l.storage.filesystem.impermanence.enable = true;
  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [
      "size=25%"
      "defaults"
      "mode=755"
    ];
  };
}
