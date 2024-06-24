{lib, config, ...}:
with lib; with builtins;
let
    cfg = config.l.environment.services;
    opt = mkOption;
in {
    options.l.environment.services = with types; opt {
	default = {};
	type = attrsOf (submodule {
	    options = {
		priority = opt {
		    default = "";
		    type = str // {
			check = (uwu: 
			    any (owo: uwu == owo)
			    ["critical" "moderate" "low"]
			);
		    };
		};
	    };
	});
    };
}
