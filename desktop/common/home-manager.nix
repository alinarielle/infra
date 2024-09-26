{lib, config, ...}: config.l.lib.mkLocalModule ./home-manager.nix "hm config" {
    home-manager = {
	useGlobalPkgs = true;
	useUserPackages = true;
    };
}
