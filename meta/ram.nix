{lib, config, ...}:
with lib; with builtins;
let
    cfg = config.l.meta.ram;
    opt = mkOption;
in {
    options.l.meta.ram = with types; {
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
