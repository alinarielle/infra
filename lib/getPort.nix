{lib, config,...}: 
with lib; with builtins;
let 
    cfg = config.l.network.getPort;
    opt = mkOption;
in 
{
    options.l.network.getPort = with types; {
	minPort = opt {
	    default = 50000;
	    type = port;
	};
	maxPort = opt {
	    default = 65535;
	    type = port;
	};
    };
    config.l.lib.net.getPort = service:
    let
	alphabet = "abcdefghijklmnopqrstuvwxyz";
            l = filter (x: x != "") (splitString "" alphabet);
            num = toIntBase10 (substring 0 19 
		(replaceStrings l (imap (i: v: toString i) l)
                    (hashString "sha256" service)));
    in (mod num (cfg.maxPort - cfg.minPort)) + cfg.minPort;
}
