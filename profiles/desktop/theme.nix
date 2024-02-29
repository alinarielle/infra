{ pkgs, config, inputs, ... }: {
    imports = [
	inputs.nix-colors.homeManagerModules.default
    ];

    colorScheme = {
	slug = "strelizia";
	name = "strelizia";
	author = "alina (https://alina.cx)";
	palette = {
	    base00 = "1d2021"; # ----
	    base01 = "383c3e"; # ---
	    base02 = "53585b"; # --
	    base03 = "6f7579"; # -
	    base04 = "d5d5d5"; # ++
	    base05 = "dddddd"; # +++
	    base06 = "e5e5e5"; # ++++
	    base07 = "fc83f4"; # pink
	    base08 = "ff15b0"; # red
	    base09 = "f49f0c"; # orange
	    base0A = "ede438"; # yellow
	    base0B = "09f921"; # green
	    base0C = "09f9f9"; # cyan
	    base0D = "2D9EF4"; # blue
	    base0E = "8d09f9"; # purple
	    base0F = "f909ad"; # magenta
	};
    };
}
