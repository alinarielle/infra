{lib, cfg, opt, ...}: {
  opt = with lib.types; {
    minPort = lib.mkOption { default = 50000; type = port; };
    maxPort = lib.mkOption { default = 65535; type = port; };
    getPort = lib.mkOption { type = raw; };
  };
  l.network.getPort = service: let
    alphabet = "abcdefghijklmnopqrstuvwxyz";
    l = lib.filter (x: x != "") (lib.splitString "" alphabet);
    num = lib.toIntBase10 (builtins.substring 0 19 
      (builtins.replaceStrings l (lib.imap (i: v: builtins.toString i) l)
        (builtins.hashString "sha256" service)));
    in (lib.mod num (cfg.maxPort - cfg.minPort)) + cfg.minPort;
}
