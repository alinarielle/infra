{lib, config, pkgs, ...}: config.l.lib.mkLocalModule ./base.nix "base packages" {
    environment.systemPackages = with pkgs; [
	tlp
	acpid
    ];
}
