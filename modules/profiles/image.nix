{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
{
  users.users.alina.packages = lib.mkOverride 400 [ ];
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
  ];
  l.profiles.base.enable = true;
  hardware.enableAllHardware = true;
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;

  # An installation media cannot tolerate a host config defined file
  # system layout on a fresh machine, before it has been formatted.
  swapDevices = lib.mkImageMediaOverride [ ];
  fileSystems = lib.mkImageMediaOverride config.lib.isoFileSystems;
  # Add Memtest86+ to the CD.
  boot.loader.grub.memtest86.enable = true;
  boot.initrd.luks.devices = lib.mkImageMediaOverride { };
  boot.postBootCommands = ''
    for o in $(</proc/cmdline); do
      case "$o" in
        live.nixos.passwd=*)
          set -- $(IFS==; echo $o)
          echo "nixos:$2" | ${pkgs.shadow}/bin/chpasswd
          ;;
      esac
    done
  '';
  system.stateVersion = lib.mkDefault lib.trivial.release;

  # use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
    "reiserfs"
    "vfat"
    "f2fs"
    "xfs"
    "ntfs"
    "cifs"
  ];
}
