{config, lib, pkgs, inputs, nodes, ...}:
let
    cfg = config.net.dns;
in {
    options.net.dns = {
	enable = lib.mkEnableOption "DNS";
	primary = lib.mkOption {
	    type = lib.types.bool;
	    description = "enables this host to be a primary DNS server";
	    default = true;
	};
	allowTransferTo = lib.mkOption {
	    # soo according to rfc 5936 AXFR stands for DNS Zone Transfer Protocol
	    # why the hell would you call it AXFR then
	    # i mean yeah it stands for Athoritive transFeR.. but why the X
	    # maybe it's a cross and means 'across'?? whatever
	    # needs to be set because exposing AXFR to everyone allows easy discovery
	    # of every host... although my entire configuration is on the internet anyway
	    # and security through obscurity doesn't work, you can just query crt.sh
	    # but it's the recommended best practice so i'm doing it in case someone
	    # scans for it and labels me as insecure such as mail providers or
	    # future employers
	    type = lib.types.listof lib.types.str;
	    description = "whitelisted IPs that can request DNS zone transfers";
	    default = [];
	};
	zones = lib.mkOption {
	    type = lib.types.attrsOf inputs.nix-dns.lib.types.zone;
	    description = "DNS zones to propagate";
	    default = {};
	};
	extraACL = lib.mkOption {
	    type = lib.types.listOf lib.types.str;
	    default = [];
	};
	zonesDir = lib.mkOption {
	    type = lib.types.str;
	    default = "nix-dns/zones";
	    description = "the /etc path for storing DNS zones";
	};
	listen = lib.mkOption {
	    type = lib.types.attrsOf (lib.types.submodule {
		options.port = lib.mkOption {
		    type = lib.types.int;
		    default = null;
		    description = "port assigned to the specified IP"; 
		};
	    });
	    description = "the IP address the DNS server is listening on";
	    example = {
		"1.1.1.1".port = 53;
		"8.8.8.8".port = 1337;
	    };
	    default = {};
	};
	user = lib.mkOption {
	    type = lib.types.str;
	    default = "root";
	    description = "the user under which the server is running";
	};
	group = lib.mkOption {
	    type = lib.types.str;
	    default = "root";
	    description = "the group under which the server is running";
	};
	dataDir = {
	    type = lib.types.str;
	    default = "/var/lib/knot";
	    description = "the directory data for knot is stored in";
	    example = "/owo/biig/knot";
	};
    };
    config = lib.mkIf cfg.enable {
	networking.firewall.allowedUDPPorts = lib.mapAttrsToList (name: value: value) cfg.listen;
	networking.firewall.allowedTCPPorts = lib.mapAttrsToList (name: value: value) cfg.listen;

	environment.etc = lib.mkIf cfg.primary (lib.mapAttrs' (name: zone: {
	    name = "${cfg.zonesDir}";
	    value = { source = pkgs.writeText "${name}.zone" (lib.toString zone);};
	}) cfg.zones);

	services.knot = {
	    enable = true;
	    keyFiles = [
		"/var/lib/secrets/dns/tsig.conf"
	    ];
	    settings = {
		server = {
		    listen = lib.mapAttrsToList (ip: port: "${ip}@${port}") cfg.listen;
		    automatic-acl = true;
		};
		log.syslog.any = "info";
		template.default = {
		    storage = "${cfg.dataDir}/zones";
		    zonefile-sync = -1;
		    zonefile-load = "difference-no-serial";
		    journal-content = "all";
		};
		user = "${cfg.user}:${cfg.group}";

		zone = lib.mapAttrs (key: val: {}) cfg.zones;
	    };
	};
	
	users.users.${cfg.user} = {
	    group = lib.mkIf (cfg.user != "root") cfg.group;
	    isSystemUser = true;
	};
	systemd.tmpfiles.settings = {
	    dataDir."${cfg.dataDir}".d = {
		group = cfg.group;
		user = cfg.user;
		mode = "770";
		age = "-";
	    };
	    zones."${cfg.dataDir}/zones".d = {
		group = cfg.group;
		user = cfg.user;
		mode = "770";
		age = "-";
	    };
	};
	systemd.services.knot.preStart = ''
	    set -euo pipefail
	    ${lib.getExe pkgs.cp} --dereference /etc/${cfg.zonesDir}/* ${cfg.dataDir}/zones''; 
	systemd.services.knot.serviceConfig.ExecReload = lib.mkForce 
	    (pkgs.writeShellScript "knot-reload" ''
		set -eou pipefail
		${lib.getExe pkgs.cp} --dereference /etc/${cfg.zonesDir}/* ${cfg.dataDir}/zones
		${lib.getExe config.services.knot.package} reload
	    '');
	systemd.services.knot.reloadTriggers =
	    lib.mapAttrsToList (name: zone: pkgs.writeText "${name}.zone" (toString zone))
	    cfg.zones;
	
	assertions = 
	(lib.mapAttrsToList (ip: port: {
	    assertion = port != null;
	    message = "DNS: the port for IP ${ip} must be specified!";
	}) cfg.listen)
	++ 
	(lib.mapAttrsToList (name: user: {
	    assertion = config.users.users.${user}.isNormalUser != true;
	    message = "DNS: can't deploy the knot daemon on a normal user";
	}) cfg.user)
	++ 
	[{
	    assertion = cfg.user != "root" && cfg.userPassword == "";
	    message = "DNS: password for user cannot be empty";
	}];

	warnings = lib.mkIf (cfg.user != "root" && cfg.group == "root")
	    ["DNS: user was changed but group not, are you sure this is what you want"];
    };
}
#TODO: secret mgmnt, impermanence, vm networking, look up what the settings actually do
# dns for *.infra.alina.cx and alina.cx
