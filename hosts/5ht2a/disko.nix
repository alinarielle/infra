{ inputs, lib, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];
  # l.boot.grub.enable = lib.mkForce false;
  l.boot.systemd-boot.enable = lib.mkForce false;
  boot.loader = {
    # grub = {
    #   enable = true;
    #   efiSupport = true;
    #   device = "/dev/disk/by-id/usb-iXpand_Flash_Drive_FCF52045F3D0-0:0-part1";
    #   useOSProber = true;
    #   enableCryptodisk = true;
    # };
    systemd-boot = {
      enable = true;
      memtest86.enable = true;
      editor = true;
    };
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
  };
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
    device = "/dev/disk/by-id/usb-iXpand_Flash_Drive_FCF52045F3D0-0:0";
    type = "disk";
    content = {
      type = "gpt";
      efiGptPartitionFirst = true;
      partitions.BIOS = {
        name = "BIOS";
        priority = 1;
        device = "/dev/disk/by-id/usb-iXpand_Flash_Drive_FCF52045F3D0-0:0-part1";
        size = "1M";
        type = "EF02";
        # attributes = [ 0 ];
      };
      partitions.ESP = {
        name = "EFI";
        priority = 2;
        size = "2G";
        type = "EF00";
        content = {
          type = "filesystem";
          device = "/dev/disk/by-id/usb-iXpand_Flash_Drive_FCF52045F3D0-0:0-part2";
          format = "vfat";
          mountpoint = "/efi";
          mountOptions = [ "umask=0077" ];
        };
      };
      partitions.LUKS = {
        size = "100%";
        content = {
          device = "/dev/disk/by-id/usb-iXpand_Flash_Drive_FCF52045F3D0-0:0-part3";
          type = "luks";
          name = "crypt";
          extraOpenArgs = [ ];
          settings = {
            allowDiscards = false;
            keyFile = "/tmp/secret.key";
            keyFileSize = 49;
            # refresh = true;
            # label = "TOUT LE MONDE DETESTE LA POLICE";
            # uuid = 13121312-1312-1312-1312-131213121312;
          };
          additionalKeyFiles = [ ];
          content = {
            type = "btrfs";
            extraArgs = [
              "--force"
              "--nodiscard"
              "--checksum blake2"
              "--label='TOUT LE MONDE DETESTE LA POLICE'"
              # "--device-uuid=13121312-1312-1312-1312-131213121312"
            ];
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
                mountOptions = [
                  #"ssd"
                ];
              };
              bites = {
                mountpoint = "/bites";
                mountOptions = [
                  #"ssd"
                ];
              };
            };
          };
        };
      };
    };
  };
}
