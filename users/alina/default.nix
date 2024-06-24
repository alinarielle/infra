{ pkgs,... }: {
    imports = [
	./shell.nix
	./pkgs.nix
	./nvim.nix
	./git.nix
	./ssh.nix
    ];
    users.users.alina = {
	shell = pkgs.zsh;
	isNormalUser = true;
	extraGroups = [ "wheel" "networkmanager" "adb" ];
	openssh.authorizedKeys.keys = [
	    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINz9IXSb6I5uzk+tl4HAiBeCFwB+hD2owIvLyIirER/D alina";
	];
	initialHashedPassword = "$6$PUIyRPFQMYLriq3g$05Qvh6stb9i47nXFb8o3/u8/iVemY3.s4tGP/znbqV246SLHTd5Qxk/VMjL1RVeOVsB7tIbW9AMFvuOeLEtic.";
    };
    home-manager = {
	users.alina.programs.home-manager.enable = true;
	users.alina.home = { 
	    username = "alina";
	    homeDirectory = "/home/alina";
	    stateVersion = "23.11";
	};	
    };
}
