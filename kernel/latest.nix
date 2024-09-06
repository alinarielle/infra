{lib, config, pkgs, ...}: config.l.lib.mkLocalModule ./latest.nix "latest linux kernel" {
	boot.kernelPackages = pkgs.linuxPackages_latest;
}
