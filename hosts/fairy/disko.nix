{inputs, lib, ...}: {
	imports = [inputs.disko.nixosModules.disko];
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
	disko.devices.disk.main = {
		device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_2TB_24443A803763";
		type = "disk";
		content = {
			type = "gpt";
			partitions.ESP = {
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
			partitions.luks = {
				size = "100%";
				content = {
					type = "luks";
					name = "main";
					extraOpenArgs = [];
					settings.allowDiscards = true;
					additionalKeyFiles = [];
					content = {
						type = "btrfs";
						extraArgs = ["-f"];
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
			};
		};
	};
}
