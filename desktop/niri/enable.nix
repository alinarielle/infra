{lib, config, ...}: {
    options.l.desktop.niri.enable = lib.mkEnableOption "niri scrollable twm";
    config = lib.mkIf config.l.desktop.niri.enable {
	l.desktop.niri = config.l.lib.enable [
	    "config" "keybinds"
	];
    };
}
