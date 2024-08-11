{lib, config, ...}: lib.mkLocalModule ./. "networkmanager configuration" {
    networking = {
	networkmanager.enable = true;
	wireless.enable = lib.mkForce false;
    };
}
