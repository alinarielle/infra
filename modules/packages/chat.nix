{pkgs, ...}: {
    users.users.alina.packages = with pkgs; [
	irssi
	catgirl
	iamb
    ];
}
