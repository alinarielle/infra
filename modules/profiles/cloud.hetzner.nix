{
  inputs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  networking.useDHCP = lib.mkDefault true;
  l.storage.filesystem.impermanence.enable = true;
  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [
      "size=25%"
      "defaults"
      "mode=755"
    ];
  };
  fileSystems."/persist".neededForBoot = true;
  boot.loader = {
    efi.canTouchEfiVariables = false;
    systemd-boot = {
      enable = true;
      memtest86.enable = true;
    };
    # grub = {
    #   enable = true;
    #   copyKernels = true;
    #   device = "/dev/sda1";
    # };
  };
  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "virtio_net"
    "virtio_blk"
    "sd_mod"
    "sr_mod"
    "btrfs"
  ];
  l.boot.systemd-boot.enable = lib.mkForce false;
  disko.devices.disk.main = {
    device = "/dev/sda";
    type = "disk";
    content = {
      type = "gpt";
      partitions.boot = {
        priority = 1;
        size = "1M";
        type = "EF02";
        # device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_110158209-part1";
      };
      partitions.ESP = {
        type = "EF00";
        size = "512M";
        # device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_110158209-part2";
        content = {
          format = "vfat";
          type = "filesystem";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };
      partitions.persist = {
        size = "100%";
        # device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_110158209-part3";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
            nix = {
              mountpoint = "/nix";
              mountOptions = [
                "noatime"
                "compress=zstd"
              ];
            };
            persist = {
              mountpoint = "/persist";
            };
          };
        };
      };
    };
  };
}
