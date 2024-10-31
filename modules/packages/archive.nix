{pkgs, ...}: {
    users.users.alina.packages = with pkgs; [
	p7zip
	zstd
	unzip
    ];
}
