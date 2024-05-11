{config, ...}:
let
    domain = config.networking.domain;
in
{
    services.knot = {
	enable = true;
	settings = {
	    server = [
		{ listen = "0.0.0.0:53" };
		{ listen = "::@53" };
	    ];
	    zone.domain."${domain}" = {
		storage = "/var/lib/knot/zones/";
		file = "${domain}.zone";
	    };
	    log = {
		target = "syslog";
		any = "info";
	    };
	};
    };
}
