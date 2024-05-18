{lib, nodes,...}:
with lib builtins;
let cfg = options.port; in
{
    options.port = {
	services = mkOption {
	    type = types.listOf types.str;
	    default = [];
	};
	minPort = mkOption {
	    type = types.port;
	    default = 50000;
	};
	maxPort = mkOptiion {
	    type = types.port;
	    default = 65535;
	};
    };
    config = 
let net.lib.getPort = args@{...}: #TODO refactor, this code is terrible alina
    let
	service = if hasAttr "service" args then args.service else null;
	host = if hasAttr "host" args then args.host else null;
	srvs = cfg.services;
	srvs-host = if host == null then null else nodes.${host}.config.port.services;
	ports = imap0 (i: v: minPort + i) srvs;
	srvs-ports = map (x: {${toString x.fst} = x.snd;}) (zipLists srvs ports);
	srvs-ports-host = map (x: {${toString x.fst} = x.snd;})(zipLists srvs-host ports);
	port = head (filter (x: hasAttr ${service} x) srvs-ports);
	port-host = head (filter (x: hasAttr ${service} x) srvs-ports-host);
    in	if host == null && service == null then {} else
	if host == null && service != null then port.${service} else
	if host != null && service == null then srvs-host else
	if host != null && service != null then port-host
	else "?????????";
in mkIf (cfg != []) {
	inherit net.lib.getPort ports;
	assertions = [{
	    assertion = any cfg.maxPort < ports;
	    message = "max port limit reached! idk how you exhausted 15k+ slots though..";
	}];
    };
}
# enter all services which need a port assigned into port.services
# both service and host arguments are optional but you need to enter at least one
# then call getPort <service> to get the port for the respective service
