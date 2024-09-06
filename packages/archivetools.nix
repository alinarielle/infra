{lib, config, pkgs, ...}: config.l.lib.mkLocalModule 
    ./archivetools.nix 
    "archive/compression related tools" 
{
    users.users.alina.packages = with pkgs; [
	p7zip
	zstd
	unzip
    ];
}
