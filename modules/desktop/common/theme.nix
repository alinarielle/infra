{ inputs, opt, lib, cfg,... }: {
    opt.colors = lib.mkOption {type = lib.types.attrs;};
     l.desktop.common.theme.colors = rec {
	dark = "141414"; # ----
	grey = "2d2d2d"; # ---
	base02 = "53585b"; # --
	base03 = "6f7579"; # -
	base04 = "d5d5d5"; # ++
	base05 = "dddddd"; # +++
	white = "ffffff"; # ++++
	pink = "fc83f4";
	red = "f91b02";
	orange = "f49f0c";
	yellow = "ede438";
	green = "b3f361";
	cyan = "09f9f9";
	blue = "2D9EF4";
	purple = "8d09f9";
	magenta = "f909ad"; 
	dark-red = "a50000";
	dark-yellow = "dce002";
	dark-green = "2ba805";
	primary = blue;
	secondary = dark;
	tertiary = pink;
    };
}
