{lib, config, ...}: {
    options.l.meta.services = with types; lib.mkOption {
	default = {};
	type = attrsOf (submodule {
	    options = {
		dns = {
		    enable = lib.mkEnableOption "configure dns";
		    fqdn = lib.mkOption { type = str; };
		    hostName = lib.mkOption { type = str; };
		    domain = lib.mkOption { type = str; };
		};
		ssl = {
		    enable = lib.mkEnableOption "request ssl cert for subdomain"
		};
		ip = {
		    enable = lib.mkEnableOption "request IP addresses";
		    
		};
	    };
	});
    }
}
