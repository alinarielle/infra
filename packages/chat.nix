{lib, config, pkgs,...}: config.l.lib.mkLocalModule ./chat.nix "chat related packages" {
    users.users.alina.packages = with pkgs; [
	gomuks
	catgirl
	irssi
    ];
}
