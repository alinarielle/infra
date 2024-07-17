{lib, config, ...}: lib.mkIf config.l.desktop.any.enable {
    home-manager = {
	useGlobalPkgs = true;
	useUserPackages = true;
    };
}
