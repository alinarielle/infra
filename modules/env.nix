{lib, ...}: {
    options.net.env = {
	primaryIP = {
	    v4 = lib.mkOption {
		type = lib.types.str;
	    };
	    v6 = lib.mkOption {
		type = lib.types.str;
	    };
	};
	nat = lib.mkOption {
	    type = lib.types.bool;
	    default = false;
	};
    };
}
