{inputs, lib, ...}: {
	imports = [inputs.disko.nixosModules.disko];
	l.filesystem.impermanence.enable = true;
	disko.devices.nodev."/" = lib.mkForce {
		fsType = "tmpfs";
		mountOptions = [
			"size=25%"
			"defaults"
			"mode=755"
		];
	};
	fileSystems."/persist".neededForBoot = true;
  boot.loader.grub.device = "/dev/vda";
  l.boot.systemd-boot.enable = lib.mkForce false;
	disko.devices.disk.main = {
		device = "/dev/disk/by-id/virtio-016422bba02848f69188";
		type = "disk";
		content = {
			type = "gpt";
			partitions.boot = {
				type = "EF02";
        size = "1024M";
			};
			partitions.luks = {
				size = "100%";
        content = {
          type = "btrfs";
          device = "/dev/disk/by-id/virtio-016422bba02848f69188-part2";
          extraArgs = ["-f"];
          subvolumes = {
            nix = {
              mountpoint = "/nix";
              mountOptions = ["noatime"];
            };
            persist = {
              mountpoint = "/persist";
            };
            home = {
              mountpoint = "/home";
              mountOptions = ["compress=zstd"];
            };
          };
				};
			};
		};
	};
}
