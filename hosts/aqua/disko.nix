{ inputs, lib, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];
  l.filesystem.impermanence.enable = true;
  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [
      "size=25%"
      "defaults"
      "mode=755"
    ];
  };
  fileSystems."/persist".neededForBoot = true;
  boot.loader.grub.device = "/dev/sda";
  l.boot.systemd-boot.enable = lib.mkForce false;
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
    type = "disk";
    content = {
      type = "gpt";
      partitions.boot = {
        type = "EF02";
        size = "1024M";
      };
      partitions.ESP = {
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
      partitions.persist = {
        size = "100%";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
            nix = {
              mountpoint = "/nix";
              mountOptions = [ "noatime" ];
            };
            persist = {
              mountpoint = "/persist";
            };
            home = {
              mountpoint = "/home";
              mountOptions = [ "compress=zstd" ];
            };
          };
        };
      };
    };
  };
}
