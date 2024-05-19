{lib, config,...}: with lib; with builtins;
let cfg = config.port; in {
    getPort = service:
    let
	alphabet = "abcdefghijklmnopqrstuvwxyz";
            l = filter (x: x != "") (splitString "" alphabet);
            num = toIntBase10 (substring 0 19 
		(replaceStrings l (imap (i: v: toString i) l)
                    (hashString "sha256" service)));
    in (mod num (cfg.maxPort - cfg.minPort)) + cfg.minPort;
}
