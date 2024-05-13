{lib, pkgs, ...}: {
    imports = [ 
	./auth.nix
	./dns
    ];
    networking.networkmanager.enable = true;
    networking.wireless.enable = lib.mkForce false;
    #networking.useNetworkd = true;
    services.mullvad-vpn.enable = true;
    services.mullvad-vpn.package = pkgs.mullvad;
    networking.domain = "alina.cx";
}
