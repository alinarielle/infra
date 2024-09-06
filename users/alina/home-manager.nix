{lib, config, ...}: config.l.lib.mkLocalModule ./home-manager.nix "home manager config" {
    home-manager = {
	users.alina.programs.home-manager.enable = true;
	users.alina.home = { 
	    username = "alina";
	    homeDirectory = "/home/alina";
	    stateVersion = "23.11";
	};
	useGlobalPkgs = true;
	useUserPackages = true;
    };
}
