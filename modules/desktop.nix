{lib, config, ...}:
with lib; with builtins;
let
cfg = config.profiles.desktop;
in {
    options.profiles.desktop = with types; {
	type = (submodule {
	    options = {
		enable = mkEnableOption "desktop";
	    };
	});
    };
    config = let
    dir = ../desktop;
    dirlist = attrNames (filterAttrs (name: type: type == "directory") (readDir dir));
    desktop-attrs = genAttrs dirlist (dir: import ./${dir});
    choice = head (attrNames cfg);
    choice-attrs = filterAttrs (name: conf: name == choice) desktop-attrs;
    in mkIf (cfg != {}) choice-attrs.common // choice-attrs.${choice};
}
