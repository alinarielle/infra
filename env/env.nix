{lib, ...}: 
with lib; 
let opt = mkOption; in {
    options.env = with types; {
	network = {
	    ip = {
		v4 = opt {
		    type = str;
		    default = "";
		};
		v6 = opt {
		    type = str;
		    default = "";
		};
	    };
	    nat = opt {
		type = bool;
		default = false;
	    };
	};
	hardware = {
	    block = {
		type = attrsOf blockDevice;
	    };
	};
    };
}
