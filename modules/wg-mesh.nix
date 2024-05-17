{config, nodes, lib, pkgs, name, ...}:
let 
    cfg = config.net.wg-mesh;
in 
with lib; {
    options.net.wg-mesh = mkOption {
	default = {};
	type = types.attrsOf (types.submodule {
	    options = {
	    	port = mkOption {
    		    type = lib.types.port;
		    default = 10000;
	    	    example = 1337;
    		};
	    	private = mkOption {
    		    type = types.nullOr types.str;
		    default = null;
		};
	    	public = mkOption {
    		    type = types.nullOr types.str;
	    	};
		peers = mkOption {
		    default = {};
		    type = types.attrsOf (types.submodule {
			options = {
			    port = mkOption {
				type = types.port;
			    };
			    public = mkOption {
				type = types.str;
			    };
			    fqdn = mkOption {
				type = types.nullOr types.str;
			    };
			    psk = lib.mkOption {
				type = types.str;
			    };
			    keepAlive = mkOption {
		    		type = types.nullOr types.int;
	    			default = null;
    			    };
			};
		    });
		};
	    };
	})
    };
    config =
    let
	net.lib.getAddress = peers: peer:
	let 
	    ips = imap (i: v: "10.0.0.${builtins.toString i}") peers;
	    host-ips = map (x: { ${x.fst} = x.snd; } ) (lib.zipLists peers ips);
	    peer-ip = head (filter (x: lib.hasAttr ${peer} x) host-ips);
	in peer-ip.${peer};
	net.lib.mkTunnel = args@{peerA, peerB}:
	let 
	    peer = head attrNames filterAttrs (key: val: ${key} != name) args;
	    peer-conf = args.${peer};
	in
	if !(hasAttr ${name} args) then {} else
	if ${args.peerA} == ${args.peerB} then {} else {
	    private = "secrets.${name}.private";
	    public = "secrets.${name}.public";
	    #port = 10000;
	    peers.${peer} = {
		fqdn = if nodes.${peer}.config.env.nat then null
		    else nodes.${peer}.config.networking.fqdn;
		keepAlive = if config.env.nat then 25 else null;
		psk = "secrets.${name}.psk.${peer}";
		#port = 10000; #TODO port abstraction
		public = "secrets.${peer}.public";
	    } // peer-conf;
	};
	net.lib.mkMesh = args@{peerA, peerB, ...}: 
	let 
	    peers = attrNames args;
	    eval = filter (x: x != {}) (unique (concatMap 
		(peer: map 
		    (peer2: if peer == peer2 then {} 
		    else {${peer} = args.${peer}; ${peer2} = args.${peer2};}) 
		peers) 
	    peers)); # returns a list with an attrs for every peer combination
	in mergeAttrsList (map (x: net.lib.mkTunnel x) eval); # returns the result of mkTunnel for every peer combination as an attrs in a list and merges them together to return a single attrs, later results take dominance
    in mkIf (cfg != {}) {
	inherit
	    net.lib.getAddress
	    net.lib.mkTunnel
	    net.lib.mkMesh; # public lib interface of the module
	
	environment.systemPackages = with pkgs; [
	    rosenpass
	    rosenpass-tools
	];
	
	systemd.network.netdevs = mapAttrs' (mesh: device: 
	    mesh = "wg-${mesh}"; 
	    device = {
	    wireguardConfig = {
		ListenPort = cfg.${mesh}.port
	    };
	    wireguardPeers = map (peer: with cfg.${mesh}.peers.${peer}; {
		PublicKey = ${public};
		Endpoint = "${fqdn}:${port}";
		AllowedIPs = [
		    "${net.lib.getAddress cfg.${mesh}.peers peer}/32"
		];
	    }) attrNames cfg.${mesh}.peers;
	}) cfg;
    };
}
#TODO: include VMS, their configs aren't passed as `nodes` but instead as 
# config.microvm.vms.*
# shellhook to generate public, private, and PSKs in sops for every host
# do BGP so two hosts behind two different NATs can connect
