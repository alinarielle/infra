{lib, config, ...}:
with lib; with builtins;
let
    cfg = config.l.environment.ram;
    opt = mkOption;
in {
    options.l.environment.ram = with types; {
	allocation = opt {
	    default = {};
	    type = attrsOf (submodule {
		options = {
		    usage = opt { default = ""; type = blockSize; };
		    benchmarks = opt { default = {}; type = attrsOf blockSize; };
		};
	    });
	};
	capacity = opt {
	    default = "";
	    type = blockSize;
	};
    };
}
