{lib, ...}: 
with lib; 
let opt = mkOption; in {
    options.env = with types; {
	net = {
	    ip = {
		v4 = opt {
		    type = str;
		};
		v6 = opt {
		    type = str;
		};
	    };
	    nat = opt {
		type = bool;
		default = false;
	    };
	};
	ram = {
	    size = opt {
		type = str;
	    };
	    alloc = opt {
		type = attrsOf (submodule {
		    options = {
			reserved = opt {
			    type = attrs;
			};
		    };
		});
	    };
	};
    };
}
