{lib, config, ...}: {
    options.l.desktop.hyprland.enable = lib.mkEnableOption 
	"hyprland tiling window manager";
    config = lib.mkIf config.l.desktop.sway.enable {
	l.desktop.hyprland = config.l.lib.enable [
	    "keybinds" "config" "hyprlock" "hypridle" "waybar"
	];
    };
}
