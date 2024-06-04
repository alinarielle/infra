{lib, config, ...}:
with lib; with builtins; {
    options.profiles.desktop = with types; mkOption {
	type = attrsOf bool;
	default = {};
    };
}
