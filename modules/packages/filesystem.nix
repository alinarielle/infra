{pkgs, ...}: {
    users.users.alina.packages = with pkgs; [
	du-dust
	fd
	tree
	lsd
	bat
	mdcat
	hexyl
	lsof
	ranger
	rsync
	rclone
    ];
}
