{ pkgs, config, inputs, ... }: {

    imports = [
	../librewolf.nix
	../cursor.nix
	../mako.nix
	../theme.nix
	../wayland.nix
	inputs.hyprland.homeManagerModules.default
    ];

    users.users.alina.packages = with pkgs; [
	xdg-desktop-portal-hyprland
	hyprland-autoname-workspaces
	hyprpicker
	hyprpaper
	hyprshade
    ];

    hardware.opengl.enable = true;
    programs.hyprland.enable = true;

    home-manager.users.alina.wayland.windowManager.hyprland = {
	enable = true;
	reloadConfig = true;
	systemdIntegration = true;
	keyBinds = {
	    
	};
    };
}
