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
  l.filesystem.impermanence.enable = true;
  disko.devices.nodev."/" = lib.mkForce {
    fsType = "tmpfs";
    mountOptions = [
      "size=2G"
      "defaults"
      "mode=755"
    ];
  };
  fileSystems."/persist".neededForBoot = true;
  disko.devices.disk.${cfg.disk} = {
    device = cfg.disk;
    type = "disk";
    content = {
      type = "gpt";
      partitions."/persist" = {
	size = "100%";
	content = {
	  format = "btrfs";
	  mountpoint = "/";
	  type = "filesystem";
	};
      };
    };
  };
}
