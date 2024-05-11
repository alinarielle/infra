{config, lib, pkgs, inputs, nix-dns, nodes, ...}: 
let
    cfg = config.net.dns;
    nodes = with lib; attrNames (filterAttrs 
	(name: type: type == "directory") 
	(builtins.readDir ../hosts)
    );
in
{
    options.net.dns = {
	enable = lib.mkEnableOption "DNS";
	primary = lib.mkOption {
	    type = lib.types.bool;
	    description = "enables this host to be a primary DNS server";
	    default = true;
	};
	allowedXFR = lib.mkOption {
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
	    type = lib.types.attrsOf nix-dns.lib.types.subzone;
	    description = "DNS zones to propagate";
	    default = {};
	};
	allZones = lib.mkOption {
	    type = lib.types.attrsOf nix-dns.lib.types.zone;
	    description = "all zones merged from all hosts which provide any";
	    default = {};
	};
	extraACL = lib.mkOption {
	    type = lib.types.listOf lib.types.str;
	    default = [];
	};
	zonesDir = lib.mkOption {
	    type = lib.types.str;
	    default = "nix-dns/zones";
	    description = "the etc path for storing DNS zones";
	};
    };
    config = lib.mkIf cfg.enable {
	networking.firewall.allowedUDPPorts = [ 53 ];
	networking.firewall.allowedTCPPorts = [ 53 ];
	
	dns.allZones = mkIf cfg.primary (lib.mkMerge 
	    (lib.mapAttrsToList (name: host: host.config.net.dns.zones)
	    nodes // lib.mkIf (config.vm != {}) config.microvm.vms));
	
    };
}
