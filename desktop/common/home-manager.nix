{self, ...}: self.lib.modules.mkLocalModule ./home-manager.nix "hm config" {
    home-manager = {
	useGlobalPkgs = true;
	useUserPackages = true;
    };
}
