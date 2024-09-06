{lib, config, pkgs, ...}: config.l.lib.mkLocalModule 
    ./crypto.nix 
    "cryptography related packages" 
{
    users.users.alina.packages = with pkgs; [
	pinentry
	gnupg
    ];
}
