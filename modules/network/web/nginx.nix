{opt, cfg, lib, ...}: {
  opt.index = with lib.types; lib.mkOption {type = listOf (submodule {
    options = {
      root = lib.mkOption { type = either [ path str ]; default = ""; };
      domain = lib.mkOption { type = str; default = ""; };
      sub = lib.mkOption { type = str; default = ""; };
      fqdn = lib.mkOption { type = str; default = ""; };
      override = lib.mkOption { type = attrs; default = {}; };
      ssl = lib.mkEnableOption "whether to enable Let's Encrypt SSL certificates";
    };
  }); default = {};};
  config = let
    acmeDir = "/var/lib/acme/acme-challenge/";
  in lib.mkMerge [{
    systemd.tmpfiles.settings.acmeDir.${acmeDir}.d = {
      group = "nginx";
      user = "nginx";
      mode = "770";
      age = "-";
      type = "d";
      };
  }] ++ (lib.mapAttrsToList 
    (key: val: {
      domain = lib.mkDefault "alina.cx";
      fqdn = lib.mkDefault (lib.mkIf (sub != "") (builtins.toString sub + ".")) + domain;
    
      services.nginx.virtualHosts.${key} = {
        serverName = val.fqdn;
	root = val.root;
      };

      security.acme.certs.${fqdn} = {
	webroot = acmeDir;
	email = "alina@duck.com";
	validMinDays = 10;
      };

    } // (lib.filterAttrs (k: v: 
      lib.any 
        (x: x == k) 
        ["root" "domain" "sub" "fqdn"]
      ) 
    val) 
    // 
    val.override)
    cfg.index
  );
}
