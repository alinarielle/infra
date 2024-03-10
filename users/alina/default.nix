{ ... }: {
    imports = [
	./shell.nix
	./pkgs.nix
    ];
    users.users.alina = {
	isNormalUser = true;
	extraGroups = [ "wheel" "networkmanager" "adb" ];
    };
    home-manager = {
	useGlobalPkgs = true;
	useUserPackages = true;
	users.alina.programs.home-manager.enable = true;
	users.alina.home = { 
	    username = "alina";
	    homeDirectory = "/home/alina";
	    stateVersion = "23.11";
	};	
    };
}
