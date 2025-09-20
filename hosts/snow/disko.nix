{ inputs, lib, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];
  fileSystems."/persist".neededForBoot = true;
  l.filesystem.impermanence.enable = true;
  disko.devices.nodev."/" = lib.mkForce {
    fsType = "tmpfs";
    device = "tmpfs";
    mountOptions = [
      "size=2G"
      "defaults"
      "mode=755"
    ];
  };
  boot.loader.grub = {
    enable = true;
    mirroredBoots = [
      {
        path = "/persist/boot";
        devices = [
          "/dev/nvme1n1"
          "/dev/nvme0n1"
        ];
      }
    ];
  };
  l.boot.systemd-boot.enable = lib.mkForce false;
  disko.devices.disk.NVME1 = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B00_S675NF0T325838";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1M";
          device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B00_S675NF0T325838-part1";
          type = "EF02";
        };
        btrfs = {
          size = "100%";
          device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B00_S675NF0T325838-part2";
          content = {
            type = "btrfs";
          };
        };
      };
    };
  };
  disko.devices.disk.NVME2 = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B00_S675NF0T325807";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1M";
          device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B00_S675NF0T325807-part1";
          type = "EF02";
        };
        btrfs = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [
              "-f"
              "-d raid1"
              "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00B00_S675NF0T325838-part2"
            ];
            subvolumes = {
              boot = {
                mountpoint = "/boot";
                mountOptions = [ "ssd" ];
              };
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
              home = {
                mountpoint = "/home";
                mountOptions = [
                  "compress=zstd"
                  "ssd"
                ];
              };
            };
          };
        };
      };
    };
  };
}
