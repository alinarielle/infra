{ ... }: {
    imports = [
	./shell.nix
	./pkgs.nix
	./nvim.nix
	./git.nix
	./ssh.nix
    ];
    users.users.alina = {
	isNormalUser = true;
	extraGroups = [ "wheel" "networkmanager" "adb" ];
    };
    users.users.alina.initialHashedPassword = "$6$PUIyRPFQMYLriq3g$05Qvh6stb9i47nXFb8o3/u8/iVemY3.s4tGP/znbqV246SLHTd5Qxk/VMjL1RVeOVsB7tIbW9AMFvuOeLEtic.";
    users.users.alina.hashedPassword = "$6$PUIyRPFQMYLriq3g$05Qvh6stb9i47nXFb8o3/u8/iVemY3.s4tGP/znbqV246SLHTd5Qxk/VMjL1RVeOVsB7tIbW9AMFvuOeLEtic.";
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
