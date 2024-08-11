{ pkgs, config, inputs, lib, config, ... }: {
    imports = [ inputs.nix-colors.homeManagerModules.default ];
    
    config.colorScheme = {
	slug = "strelizia";
	name = "strelizia";
	author = "alina (https://alina.cx)";
	palette = {
	    dark = "141414"; # ----
	    grey = "2d2d2d"; # ---
	    base02 = "53585b"; # --
	    base03 = "6f7579"; # -
	    base04 = "d5d5d5"; # ++
	    base05 = "dddddd"; # +++
	    white = "ffffff"; # ++++
	    pink = "fc83f4"; # pink
	    red = "ff15b0"; # red
	    orange = "f49f0c"; # orange
	    yellow = "ede438"; # yellow
	    green = "b3f361"; # green
	    cyan = "09f9f9"; # cyan
	    blue = "2D9EF4"; # blue
	    purple = "8d09f9"; # purple
	    magenta = "f909ad"; # magenta
	};
    };
}
