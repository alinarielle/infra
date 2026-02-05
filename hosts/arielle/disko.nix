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

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

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
