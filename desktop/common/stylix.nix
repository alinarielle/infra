{lib, config, pkgs,...}: {
    stylix = {
	enable = true;
	image = ../wallpaper.png; # extend by a collection of unsplash images and select
	# depending on darkness/colors by day phases (darker at night) and also blur them
	polarity = "dark";
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
