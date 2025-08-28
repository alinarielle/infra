{opt, cfg, lib, ...}: {
  opt.ensure = with lib.types; lib.mkOption { 
    default = {}; 
    type = attrsOf (submodule {
      options = {
        user = lib.mkOption { default = null; type = nullOr str; };
        database = lib.mkOption { default = null; type = nullOr str; };
        password = lib.mkOption { default = null; type = nullOr path; };
        DBOwnership = lib.mkEnableOption "whether to grant all privileges";
      };
    }); 
  };
  config = let

    ensure = lib.mapAttrs 
      (key: val: val // {
        user = if (val.user != null) then val.user else key;
        database = if (val.database != null) then val.user else key;
        password = if (val.password != null) then val.password else "/run/secrets/${key}_db";
      }) 
      cfg.ensure;

  in {
    services.postgresql = {
      enable = true;

      ensureUsers = map
        (elem: { name = elem.user; })
        (lib.attrValues ensure);

      ensureDatabases = lib.foldl'
        (acc: elem: acc ++ [elem.database])
        []
        (lib.attrValues ensure);

      settings = {
        log_connections = true;
        log_statement = "all";
        logging_collector = true;
        log_disconnections = true;
      };
    };
  };
}
