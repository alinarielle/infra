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
  config = {
    services.nginx.package = pkgs.nginxQuic;
    services.nginx.virtualHosts = lib.mapAttrs (key: val: {
      serverName = val.fqdn;
      root = val.root;
      quic = true;
    }) cfg;
    security.acme.certs = lib.mkMerge (lib.attrValues (lib.mapAttrs (key: val: { 
      ${val.fqdn} = lib.mkIf val.ssl {
	webroot = "/var/lib/acme/acme-challenge/";
	email = "alina@duck.com";
	validMinDays = 10;
	keyType = "ec256";
	directory = "/var/lib/acme/${key}";
	credentialFiles = {
	  "RFC2136_TSIG_SECRET_FILE" = "/secrets/acme/tsig-secret-${val.fqdn}.org";
	};
      };
    }) cfg));
  };
}
