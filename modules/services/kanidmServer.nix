{opt, cfg, lib, ...}: {
  opt.oauth2 = lib.mkOption { default = {}; type = lib.types.attrs; };
  sops.secrets.kanidm_admin_password = {};
  services.kanidm = {
    enableServer = true;
    serverSettings = {
      bindaddress = "[::]:443";
      origin = "https://auth.alina.dog";
      domain = "auth.alina.dog";
      tls_key = "";
      tls_chain = "";
      log_level = "info";
    };
    provision = {
      enable = true;
      autoRemove = true;
      persons.alina = {
        present = true;
        mailAddresses = ["alina@duck.com"];
        legalName = "alina arielle amelie";
        groups = ["admin" "idm_admins"];
        displayName = "alina";
      };
      groups.admin = {
        present = true;
        overwriteMembers = true;
        members = ["alina"];
      };
      systems.oauth2 = lib.mapAttrs (key: val: 
        {
          public = true;
          present = true;
        } // val
      ) cfg.oauth2;
      idmAdminPasswordFile = config.sops.secrets.kanidm_admin_password.path;
      adminPasswordFile = config.sops.secrets.kanidm_admin_password.path;
    };
  };
}
# TODO: what the heck is a oauth2 resource server??
