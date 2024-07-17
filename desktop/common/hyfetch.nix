{lib, config, ...}: lib.mkIf config.l.desktop.any.enable {
    home-manager.users.alina.programs.hyfetch = {
	enable = true;
	settings = {
	    preset = "transgender";
	    mode = "rgb";
	    light_dark = "dark";
	    color_align = {
		mode = "horizontal";
	    };
	};
    };
}
