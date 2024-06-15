{lib, ...}: with lib; {
    options.port = let opt = lib.mkOption; in {
	minPort = opt { 
	    type = types.int;
	    default = 50000;
	};
	maxPort = opt {
	    type = types.int;
	    default = 65535;
	};
    };
}
