{
  pkgs,
  lib,
  config,
  ...
}:
{
  #sops.secrets.vikunjaDatabase = {};
  sops.secrets.vikunjaJWT = { };
  services.vikunja = {
    enable = true;
    database.database = "postgres";
    frontendHostname = "vikunja.alina.dog";
    frontendScheme = "https";
    environmentFiles = [ ];
    settings = {
      service = {
        #JWTSecret.file = config.sops.secrets.vikunjaJWT.path;
        unixsocket = "/run/vikunja/vikunja.socket";
        unixsocketmode = "0o660";
        publicurl = "https://vikunja.alina.dog";
        motd = "woof! :3";
        enablelinksharing = true;
        enableregistration = false;
        timezone = "CEST";
        enableemailreminders = true;
        enableuserdeletion = true;
        #customlogourl = "";
        enablepublicteams = true;
        #enableopenidteamusersearch = true;
      };
      sentry.enabled = false;
      typesense.enabled = false;
      redis.enabled = false;
      mailer.enabled = false;
      database = {
        #password.file = config.sops.secrets.vikunjaDatabase.path;
        type = "postgres";
        sslmode = false;
      };
      backgrounds = {
        enabled = true;
        providers.upload = true;
      };
      auth = {
        openid = {
          enabled = true;
          providers = { };
        };
      };
      metrics = {
        enabled = true;
      };
      defaultsettings = {
        discoverable_by_name = true;
        timezone = "CEST";
      };
    };
  };
  l.metrics.endpoints = [
    {
      url = "https://vikunja.alina.dog";
    }
  ];
}
