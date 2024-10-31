{inputs, config, pkgs,...}: {
    imports = [ inputs.stylix.nixosModules.stylix ];
    stylix = {
	enable = true;
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
