{lib, config, ...}: config.l.lib.mkLocalModule ./networkmanager.nix "networkmanager" {
    networking = {
	networkmanager.enable = true;
	wireless.enable = lib.mkForce false;
    };
}
