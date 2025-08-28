{lib, pkgs, config, ...}: {
  l.db.ensure.forgejo.DBOwnership = true;
  sops.secrets.forgejo_db = { owner = "forgejo"; };

  l.network.nginx.upstreams.forgejo.servers."unix:/run/forgejo/forgejo.sock" = {};
  l.network.nginx.vhosts."git.alina.cx".locations."/" = {
    proxyPass = "http://forgejo";
    extraConfig = ''
      proxy_set_header Connection $http_connection;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      client_max_body_size 512M;
    '';
  };

  l.services.kanidm.groups = {
    forgejo_access = {};
    forgejo_admins = {};
  };
  l.services.kanidm.oauth2.forgejo = {
    removeOrphanedClaimMaps = false;
    scopeMaps.forgejo_access = ["openid" "email" "profile"];
    displayName = "Forgejo";
    preferShortUsername = true;
    claimMaps.groups = {
      joinType = "array";
      valuesByGroup = {
        forgejo_admins = [ "admin" ];
        forgejo_access = [ "access" ];
      };
    };
    originLanding = "https://git.alina.cx/explore";
    originUrl = "https://git.alina.cx/login/oauth/authorize";
  };

  services.forgejo = {
    enable = true;
    database = {
      type = "postgres";
      host = "::1";
      createDatabase = false;
      passwordFile = config.sops.secrets.forgejo_db.path;
    };
    settings = {
      session = {
        COOKIE_SECURE = true;
      };
      server = {
        PROTOCOL = "http+unix";
        DOMAIN = "git.alina.cx";
      };
      "cron.sync_external_users" = {
        RUN_AT_START = true;
        SCHEDULE = "@every 24h";
        UPDATE_EXISTING = true;
      };
      "repository.signing" = {
        DEFAULT_TRUST_MODEL = "committer";
      };
      mailer = {
        ENABLED = false;
        MAILER_TYPE = "sendmail";
        FROM = "noreply@alina.cx";
        SENDMAIL_PATH = "${pkgs.system-sendmail}/bin/sendmail";
      };
    };
  };
}
#TODO: OIDC, iocaine, perses, victoriametrics
