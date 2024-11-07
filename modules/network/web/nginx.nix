{opt, cfg, lib, pkgs, ...}: {
  opt = with lib.types; lib.mkOption {type = listOf (submodule {
    options = {
      root = lib.mkOption { type = nullOr path; };
      domain = lib.mkOption { type = str; };
      sub = lib.mkOption { type = str; };
      fqdn = lib.mkOption { type = str; };
      ssl = lib.mkOption { type = bool; default = true; };
    };
  }); default = {};};
  config = let
    acmeDir = "/var/lib/acme/acme-challenge/";
  in lib.mkMerge (lib.mapAttrsToList (key: val: {
      services.nginx.package = pkgs.nginxQuic;

      services.nginx.virtualHosts.${key} = {
        serverName = val.fqdn;
	root = val.root;
	quic = true;
      };

      security.acme.certs.${fqdn} = lib.mkIf val.ssl {
	webroot = acmeDir;
	email = "alina@duck.com";
	validMinDays = 10;
	keyType = "ec256";
	directory = "/var/lib/acme/${key}";
	credentialFiles = {
	  "RFC2136_TSIG_SECRET_FILE" = "/secrets/acme/tsig-secret-${fqdn}.org"
	};
      };
    })
  cfg);
}
