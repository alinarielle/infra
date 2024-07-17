{lib, config, ...}:
let
    cfg = config.l.meta.services;
in {
    options.l.meta.services = with lib.types; {
	wrap = lib.mkOption { type = listOf (submodule {
	    options = {
		name = lib.mkOption { type = str; };
		priority = lib.mkOption { type = enum [ "critical" "moderate" "low" ]; };
	    };
	});};
    };
    config = mkMerge (map (x: {
	l.dns.services = [{
	    A = {
		enable = true;
		ip = lib.net.getAddress { name = x.name; };
	    };
	    AAAA = {
		enable = true;
		ip = lib.net.getAddress { name = x.name; };
	    };
	    name = x.name;
	}];
	l.network #TODO add firewall rules, add nginx entry, route traffic from localhost
	# with port of getPort <name> to public
	l.vm.${x}.failoverMigration = mkIf (x.priority == "critical") {
	    enable = true;
	};
	l.impermanence.keep = [ "/srv/${x}" ];
    }) cfg.wrap);
}
