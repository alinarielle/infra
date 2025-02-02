{ inputs, ...}: {
  imports = [ inputs.disko.nixosModules.disko ];
  disko.devices.disk."sda" = {
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_56549447";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
	boot = {
	  size = "1M";
	  type = "EF02";
	};
	ESP = {
	  type = "EF00";
	  size = "512M";
	  content = {
	    type = "filesystem";
	    format = "vfat";
	    mountpoint = "/boot";
	    mountOptions = [ "umask=0077" ];
	  };
	};
	persist = {
	  size = "100%";
	  content = {
	    format = "btrfs";
	    mountpoint = "/persist";
	    type = "filesystem";
	  };
	};
      };
    };
  };
}
