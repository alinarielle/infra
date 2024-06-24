{lib, config, ...}:
with lib; with builtins;
let
    cfg = config.l.desktop;
    opt = mkOption;
in {
    options.l.desktop = with types; opt {
	default = {};
	type = attrsOf (submodule {
	    options.newLayout = mkEnableOption "new fs layout for /home";
	};
    };
    config = mkMerge [
	(attrValues
	    mapAttrs (user: conf:
		(mkIf cfg.${user}.newLayout {
		    systemd.tmpfiles.settings.snowy = genAttrs 
			(map (uwu: "/home/${user}/" + uwu )[
			    "stash/src/flake"
			    "stash/docs"
			    "blob/pictures"
			    "blob/videos"
			])
			{
			    group = ${user};
			    user = ${user};
			    mode = "770";
			    age = "-";
			    type = "d";
			};
		    l.impermanence.keep = (attrNames 
			config.systemd.tmpfiles.settings.snowy);
		})
	    ) cfg;
	)
    ];
}
