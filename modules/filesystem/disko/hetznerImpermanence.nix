{inputs, opt, cfg, lib, ...}: {
  imports = [inputs.disko.nixosModules.disko];
  opt = with lib.types; {
    disk = lib.mkOption {
      type = nullOr str; default = null;
    };
  };
  assertions = [{
    assertion = cfg.disk != null;
    message  = "option ${cfg}.disk must be set!";
  }];
  boot.loader.grub.device = "/dev/sda";
  l.boot.systemd-boot.enable = lib.mkForce false;
  disko.devices.disk.${cfg.disk} = {
    device = cfg.disk;
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
	"/persist" = {
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
}
