{ inputs, lib, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];
  # l.storage.filesystem.impermanence.enable = true;
  boot.initrd.luks.devices."main".device = "/dev/disk/by-uuid/e9f801b8-d606-4391-b06a-140ac52eb128";
  boot.initrd.availableKernelModules = ["sd_mod" "xhci_pci" "nvme"  "btrfs"];
  # disko.devices.nodev."/" = {
  #   fsType = "tmpfs";
  #   device = "none";
  #   mountOptions = [
  #     "size=2G"
  #     "defaults"
  #     "mode=755"
  #   ];
  # };
  # fileSystems."/persist".neededForBoot = true;
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-WD_BLACK_SN770M_2TB_251147400077";
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
          device = "/dev/disk/by-id/nvme-WD_BLACK_SN770M_2TB_251147400077-part1";
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
          device = "/dev/disk/by-id/nvme-WD_BLACK_SN770M_2TB_251147400077-part2";
          extraOpenArgs = [ ];
          settings.allowDiscards = true;
          additionalKeyFiles = [ ];
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
	    mountPoint = "/";
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
              home = {
                mountpoint = "/home";
                mountOptions = [ "ssd" ];
              };
            };
          };
        };
      };
    };
  };
}
