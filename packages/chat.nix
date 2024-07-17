{lib, config, pkgs,...}: lib.mkLocalModule ./. "chat related packages" {
    users.users.alina.packages = with pkgs; [
	gomuks
	catgirl
	irssi
    ];
}
