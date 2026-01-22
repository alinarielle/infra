{ inputs, lib, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];
  l.storage.filesystem.impermanence.enable = true;
  disko.devices.nodev."/" = lib.mkForce {
    fsType = "tmpfs";
    mountOptions = [
      "size=2G"
      "defaults"
      "mode=755"
    ];
  };
  fileSystems."/persist".neededForBoot = true;
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/wwn-0x600508b1001c5db354648468c941abbb";
    type = "disk";
    content = {
      type = "gpt";
      partitions.ESP = {
        priority = 1;
        name = "ESP";
        start = "1M";
        end = "512M";
        type = "EF00";
        content = {
          type = "filesystem";
          device = "/dev/disk/by-id/wwn-0x600508b1001c5db354648468c941abbb-part1";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };
      partitions.luks = {
        size = "100%";
        content = {
          type = "luks";
          name = "main";
          device = "/dev/disk/by-id/wwn-0x600508b1001c5db354648468c941abbb-part2";
          extraOpenArgs = [ ];
          settings.allowDiscards = true;
          additionalKeyFiles = [ ];
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes = {
              nix = {
                mountpoint = "/nix";
                mountOptions = [
                  "noatime"
                  "ssd"
                ];
              };
              persist = {
                mountpoint = "/persist";
                mountOptions = [ "ssd" ];
              };
            };
          };
        };
      };
    };
  };
}
