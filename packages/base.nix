{lib, config, pkgs, ...}: lib.mkLocalModule ./. "base packages" {
    environment.systemPackages = with pkgs; [
	tlp
	acpid
    ];
}
