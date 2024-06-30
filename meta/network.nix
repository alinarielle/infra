{lib, config, ...}:
with lib; with builtins;
let 
    opt = mkOption;
    cfg = config.l.environment.network;
in {
    options.l.environment.network = with types; {
	hostName = opt { default = config.networking.hostName; type = str; };
	domain = opt { default = config.networking.domain; type = str; };
	fqdn = opt { default = config.networking.fqdn; type = str; };
	isBehindNAT = opt { type = bool; default = true; };
	ipAddresses = {
	    v4 = opt { default = {}; type = attrsOf (submodule {
		options = {
		    connectedDevices = opt { default = {}; type = attrs; };
		    primary = opt { type = with lib.types.ipAddresses; v4 };
		};
	    });};
	    v6 = opt { default = {}; type = attrsOf (submodule {
		options = {
		    connectedDevices = opt { default = {}; type = attrs; };
		    primary = opt { type = with lib.types.ipAddresses; v6 };
		};
	    });};
	    any = opt { default = {}; type = attrsOf (submodule {
		options = {
		    connectedDevices = opt { default = {}; type = attrs; };
		    type = opt { type = str // { 
			check = (uwu: (uwu == "v4") || (uwu == "v6"));
		    };};
		    primary = opt { type = oneOf with lib.types.ipAddresses; [ v4 v6 ]};
		};
	    });};
	    
	};
    };
}
