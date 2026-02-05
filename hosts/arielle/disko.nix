{ config, inputs, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.disko.nixosModules.disko
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
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
  boot.initrd.luks.devices."main".device = "/dev/disk/by-uuid/e9f801b8-d606-4391-b06a-140ac52eb128";
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
          mountpoint = "/efi";
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
