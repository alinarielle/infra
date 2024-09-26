{lib, config, ...}: config.l.lib.mkLocalModule ./hyfetch.nix "flexing specs" {
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
