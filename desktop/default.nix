{lib, config, ...}:
with lib; with builtins;
let
    cfg = config.l.desktop;
    opt = mkOption;
in {
    options.l.desktop = with types; opt {
	default = {};
	type = attrsOf (submodule { 
	    options = {};
	});
    };
    imports = [
	./sway
	./niri
	./hyprland
    ];
}
