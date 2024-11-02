{inputs, config, pkgs,...}: {
    imports = [ inputs.stylix.nixosModules.stylix ];
    stylix = {
	enable = true;
	base16Scheme = "${pkgs.base16-schemes}/share/themes/eris.yaml";
	polarity = "dark";
	image = ../sway/wallpaper.png;
	fonts = {
	    serif = config.stylix.fonts.sansSerif;
	    sansSerif = {
		package = pkgs.nerdfonts;
		name = "JetBrainsMono Nerd Font Propo";
	    };
	    monospace = {
		package = pkgs.nerdfonts;
		name = "JetBrainsMono Nerd Font Mono";
	    };
	};
    };
}
