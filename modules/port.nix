{lib, nodes, ...}: 
with lib builtins; {
    options.port = let opt = mkOption; in {
	minPort = opt { 
	    type = types.int;
	    default = 50000;
	};
	maxPort = opt {
	    type = types.int;
	    default = 65535;
	};
    };
    config = 
	let cfg = config.port;
	    net.lib.getPort = service:
	    let
		alphabet = "abcdefghijklmnopqrstuvwxyz";
		l = filter (x: x != "") (splitString "" alphabet);
		num = toIntBase10 (replaceChars l (imap (x: v: toString i) l) 
		    (hashString "sha256" service));
	    in mod num (cfg.maxPort - cfg.minPort);
	in { inherit net.lib.getPort; };
};
