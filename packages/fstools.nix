{lib, config, pkgs, ...}: lib.mkLocalModule "filesystem related tools" {
    users.users.alina.packages = with pkgs; [
	du-dust
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
