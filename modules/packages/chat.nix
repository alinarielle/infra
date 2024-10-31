{pkgs, ...}: {
    users.users.alina.packages = with pkgs; [
	gomuks
	catgirl
	irssi
    ];
}
