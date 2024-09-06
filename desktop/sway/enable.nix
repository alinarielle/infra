{lib, config, ...}: {
    options.l.desktop.sway.enable = lib.mkEnableOption "sway tiling window manager";
    config = lib.mkIf config.l.desktop.sway.enable {
	l.desktop.sway = config.l.lib.enable [
	    "config" "waybar" "swaylock"
	];
    };
}
