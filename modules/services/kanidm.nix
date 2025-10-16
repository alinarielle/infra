{
  config,
  opt,
  cfg,
  lib,
  pkgs,
  ...
}:
{
  opt.oauth2 = lib.mkOption {
    default = { };
    type = lib.types.attrs;
  };
  opt.groups = lib.mkOption {
    default = { };
    type = lib.types.attrs;
  };
  sops.secrets.kanidm_admin_password = { };
  security.acme = {
    acceptTerms = true;
    certs."auth.alina.dog" = {
      email = "alina@duck.com";
      validMinDays = 10;
      webroot = "/var/lib/acme/acme-challenge/";
      group = "kanidm";
    };
  };

  services.kanidm = {
    package = pkgs.kanidmWithSecretProvisioning;
    enableServer = true;
    enableClient = true;
    clientSettings.uri = "https://auth.alina.dog";
    serverSettings = {
      bindaddress = "[::1]:8443";
      origin = "https://auth.alina.dog";
      domain = "auth.alina.dog";
      tls_key = "/var/lib/acme/auth.alina.dog/key.pem";
      tls_chain = "/var/lib/acme/auth.alina.dog/fullchain.pem";
      log_level = "info";
    };
    provision = {
      enable = true;
      autoRemove = true;
      instanceUrl = "https://auth.alina.dog:8443";
      persons.alina = {
        present = true;
        mailAddresses = [ "alina@duck.com" ];
        legalName = "alina arielle amelie";
        displayName = "alina";
      };
      groups = (
        lib.mapAttrs (
          key: val:
          {
            present = true;
            overwriteMembers = true;
            members = [ "alina" ];
          }
          // val
        ) cfg.groups
      );

      systems.oauth2 = lib.mapAttrs (
        key: val:
        {
          public = true;
          present = true;
          enableLocalhostRedirects = true;
        }
        // val
      ) cfg.oauth2;
      idmAdminPasswordFile = config.sops.secrets.kanidm_admin_password.path;
      adminPasswordFile = config.sops.secrets.kanidm_admin_password.path;
    };
  };
}
