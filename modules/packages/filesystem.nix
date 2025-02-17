{pkgs, ...}: {
    users.users.alina.packages = with pkgs; [
	du-dust
	btrfs-progs
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
