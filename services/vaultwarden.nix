{config, ...}:
let
    domain = config.networking.domain;
    sub = "vault";
in
{
    sops.secrets."vaultwarden_env" = {
	owner = "vaultwarden";
	restartUnits = [ "vaultwarden.service" ];
    };

    services.vaultwarden = {
	enable = true;
	dbBackend = "postgresql";
	backupDir = "/var/backup/vaultwarden";
	config = {
	    DOMAIN = "https://" + domain;
	    WEBSOCKET_ENABLED = "true";
	    WESOCKET_PORT  = "3012";
	    DATA_FOLDER = "/var/vaultwarden";
	    DATABASE_URL = "postgresql:///vaultwarden";
	    SIGNUPS_ALLOWED = "false";
	    SIGNUPS_VERIFY = "true";
	    INVITATION_ORG_NAME = sub + "." + domain;
	    SMTP_HOST = "mail." + domain;
	    SMTP_FROM = sub + "@" + domain;
	    SMTP_FROM_NAME = sub + "." + domain;
	    SMTP_USERNAME = "no-reply@" + domain;
	    ROCKET_PORT = "8001";
	};
	environmentFile = config.sops.secrets."vaultwarden_env".path;
    };

    services.postgresql = {
	enable = true;
	ensureDatabases = [ "vaultwarden" ];
	ensureUsers = [{
	    name = "vaultwarden";
	    ensurePermissions."DATABASE vaultwarden" = "ALL PRIVILEGES";
	}];
    };
    services.nginx.virtualHosts."${toString sub + "." + domain}" = {
	enableACME = true;
	forceSSL = true;
	locations = {
	    "/" = {
		proxyPass = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}";
	    };
	    "/notifications/hub" = {
		 proxyPass = "http://localhost:${toString config.services.vaultwarden.config.WEBSOCKET_PORT}";
		 proxyWebsockets = true;
	    };
	    "/notifications/hub/negotiate" = {
		proxyPass = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}";
		proxyWebsockets = true;
	    };
	};
    };
    
    environment.persistence."/persist".directories = 
	if ( builtins.hasAttr "persistence" config.environment ) then [
	    ${toString config.services.vaultwarden.config.DATA_FOLDER}
	    ${toString config.services.vaultwarden.backupDir}
	]; else [];
}

#TODO: mail server, secret mgmt, web server, restic backups, database con, VM
