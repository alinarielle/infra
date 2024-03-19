{lib, ...}: {
    imports = [ ./auth.nix ];
    networking.networkmanager.enable = true;
    networking.wireless.enable = lib.mkForce false;
}
