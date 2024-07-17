{lib, config, ...}:
with lib; 
let
    cfg = config.l.users.import;
    opt = mkOption;
in {
    imports = [
	./root
	./alina
	./defaultShell.nix
    ];
    options.l.users.import = with types; opt { 
	type = listOf str; 
	default = [ "root" "alina" ]; 
    };
    config = mkMerge (map (user: {
	l.users.${user}.enable = true;
    }) cfg);
}
