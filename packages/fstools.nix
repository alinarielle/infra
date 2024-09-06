{lib, config, pkgs, ...}: config.l.lib.mkLocalModule 
    ./fstools.nix 
    "filesystem related tools" 
{
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
