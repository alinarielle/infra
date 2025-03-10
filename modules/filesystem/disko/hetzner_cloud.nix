{ inputs, lib, ...}: {
  imports = [ inputs.disko.nixosModules.disko ];
  boot.loader.grub.device = "/dev/sda";
  l.boot.systemd-boot.enable = lib.mkForce false;
  disko.devices.disk."sda" = {
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_56549447";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        boot = {
	  type = "EF02";
	  size = "1024M";
	};
	ESP = {
	  type = "EF00";
	  size = "1024M";
	  content = {
	    type = "filesystem";
	    format = "vfat";
	    mountpoint = "/boot";
	    mountOptions = [ "umask=0077" ];
	  };
	};
	root = {
	  size = "100%";
	  content = {
	    format = "btrfs";
	    mountpoint = "/";
	    type = "filesystem";
	  };
	};
      };
    };
  };
}
