{ pkgs, config, inputs, lib, ... }: {

    imports = [
	./keybinds.nix
	../sway/swaylock.nix
	../sway/waybar.nix # TODO replace bar with something prettier
	../common
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

    home-manager.users.alina = {
	imports = [ inputs.hyprland.homeManagerModules.default ];
	wayland.windowManager.hyprland = {
	    enable = true;
	    reloadConfig = true;
	    systemdIntegration = true;
	    recommendedEnvironment = true;
	    #xwayland.enable = if config.l.hidpi then false else true;
	    config.exec_once = [
	        "${lib.getExe pkgs.waybar}"
	    ];
	};
	#xdg.desktopPortals = {
	#    xdgOpenUsePortal = true;
	#    enable = true;
	#    portals = let useIn = [ "Hyprland" ]; in {
	#	hyprland = {
	#	    package = pkgs.xdg-desktop-portal-hyprland;
	#	    inherit useIn;
	#	};
	#    };
	#};
    };
}

