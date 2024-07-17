{lib, config, pkgs, ...}: lib.mkLocalModule "archive/compression related tools" {
    users.users.alina.packages = with pkgs; [
	p7zip
	zstd
	unzip
    ];
}
