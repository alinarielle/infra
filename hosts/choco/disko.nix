{inputs, ...}: {
  imports = [inputs.disko.nixosModules.disko];
  fileSystems."/persist".neededForBoot = true;
  l.filesystem.impermanence.enable = true;
  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [
      "size=2G"
      "defaults"
      "mode=755"
    ];
  };
  disko.devices.lvm_vg.pool1 = {
    type = "lvm_vg";
    lvs = {
      btrfs = {
	size = "500G";
	name = "btrfs1";
      };
      ceph = {
	size = "100%";
      };
    };
  };
  disko.devices.lvm_vg.pool2 = {
    type = "lvm_vg";
    lvs = {
      btrfs = {
	size = "500G";
	content = {
	  type = "btrfs";
	  extraArgs = ["-f" "-d raid1" "/dev/mapper/luks1-btrfs1"];
	  subvolumes = {
	    "/nix" = {
	      mountpoint = "/nix";
	      mountOptions = ["ro" "noatime" "ssd"];
	    };
	    "/persist" = {
	      mountpoint = "/persist";
	      mountOptions = ["ssd"];
	    };
	    "/home" = {
	      mountpoint = "/home";
	      mountOptions = ["compress=zstd" "ssd"];
	    };
	  };
	};
      };
      ceph = {
	size = "100%";
      };
    };
  };
  disko.devices.zpool.gaypool = {
    type = "zpool";
    mode = "";
    mountpoint = null;
    datasets = {
      encrypted_zfs = {
	type = "zfs_fs";
	options = {
	  mountpoint = "/zfs";
	  encryption = "aes-256-gcm";
	  keyformat = "raw";
	  keylocation = "file:///persist/secrets/gaypool_keyfile.bin";
	  ashift = "12";
	  acltype = "posixacl";
	  compression = "zstd";
	  relatime = "on";
	  normalization = "formD";
	  dnodesize = "auto";
	  xattr = "sa";
	};
      };
    };
  };
  disko.devices.disk.NVME1 = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_2TB_24443A800844"; 
    # boot from here cuz the other NVME is on a PCIe adapter 
    # and i don't want to check for compatability in my firmware
    content = {
      type = "gpt";
      partitions = {
	ESP = {
	  priority = 1;
	  name = "ESP";
	  start = "1M";
	  end = "512M";
	  type = "EF00";
	  content = {
	    type = "filesystem";
	    format = "vfat";
	    mountpoint = "/boot";
	    mountOptions = ["umask=0077"];
	  };
	};     
	pool1 = {
	  size = "100%";
	  content = {
	    type = "luks";
	    name = "luks1";
	    extraOpenArgs = [];
	    settings = {
	      allowDiscards = true; # what does this even do
	    };
	    additionalKeyFiles = [];
	    content = {
	      type = "lvm_pv";
	      vg = "pool1";
	    };
	  };
	};
      };
    };
  };
  disko.devices.disk.NVME2 = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-Western_Digital_SN730E_22234G804674";
    content = {
      type = "gpt";
      partitions = {
    	pool2 = {
	  size = "100%";
	  content = {
	    type = "luks";
	    name = "luks2";
	    extraOpenArgs = [];
	    settings = {
	      allowDiscards = true; # what does this even do
	    };
	    additionalKeyFiles = [];
	    content = {
	      type = "lvm_pv";
	      vg = "pool2";
	    };
	  };
	};
      };
    };
  };
  disko.devices.disk.HDD1 = {
    type = "disk";
    device = "/dev/disk/by-id/ata-WDC_WD40EFZX-68AWUN0_WD-WX52DB13181T";
    content = {
      type = "gpt";
      partitions.zfs = {
	size = "100%";
	content = {
	  type = "zfs";
	  pool = "gaypool";
	};
      };
    };
  };
  disko.devices.disk.HDD2 = {
    type = "disk";
    device = "/dev/disk/by-id/ata-WDC_WD4000F9YZ-09N20L1_WD-WCC5D2SUA0VF";
    content = {
      type = "gpt";
      partitions.zfs = {
	size = "100%";
	content = {
	  type = "zfs";
	  pool = "gaypool";
	};
      };
    };
  };
  disko.devices.disk.HDD3 = {
    type = "disk";
    device = "/dev/disk/by-id/ata-WDC_WD40EFZX-68AWUN0_WD-WX52DB1311A4";
    content = {
      type = "gpt";
      partitions.zfs = {
	size = "100%";
	content = {
	  type = "zfs";
	  pool = "gaypool";
	};
      };
    };
  };
}
