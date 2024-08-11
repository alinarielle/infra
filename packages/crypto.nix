{lib, config, pkgs, ...}: lib.mkLocalModule ./. "cryptography related packages" {
    users.users.alina.packages = with pkgs; [
	pinentry
	gnupg
    ];
}
