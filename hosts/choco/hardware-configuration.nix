{config, lib, pkgs, modulesPath, ...}:{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6E9B-959B";
      fsType = "vfat";
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/4028fefb-94b1-46ca-8b4b-2914adb37903";
      fsType = "btrfs";
    };

  boot.initrd.luks.devices."nvme".device = "/dev/disk/by-uuid/9a109933-62fe-49ef-baa8-120ee72e8b88";

  fileSystems."/home/alina/hdd" =
    { device = "/dev/disk/by-uuid/4d535a39-2f7b-4ee1-a27a-3651d7dda369";
      fsType = "btrfs";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
