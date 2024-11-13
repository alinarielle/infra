{config, cfg, lib, opt, nodes, ...}: {
  opt = with lib.types; lib.mkOption { default = {}; type = attrsOf (submodule {
    options = {
      rosenpass = lib.mkOption { default = true; type = bool; };
      port = lib.mkOption { type = port; default = config.l.network.getPort "wg-mesh"; };
      fqdn = lib.mkOption { type = str; default = config.networking.fqdn; };
    };
  });};
  config = {
    
  };
}
