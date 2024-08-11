{config, nodes, lib, pkgs, name, ...}:
with lib; with builtins;
let opt = lib.mkOption; in {
    options.net.wg-mesh = with types; opt{
	default = {};
	type = attrsOf (submodule {
	    options = {
		rosenpass = opt {
		    type = types.bool;
		    default = true;
		};
		self = opt { type = str; default = name;};
	    	port = opt { type = port; };
	    	private = opt { type = str; };
	    	public = opt { type = str; };
		ip = opt { type = enum [ ip.v4 ip.v6 ];};
		peers = opt {
		    default = {};
		    type = attrsOf (submodule { options = {
			    port = opt { type = port; };
			    ip = opt { type = enum [ ip.v4 ip.v6 ];};
			    public = opt { type = str; };
			    fqdn = opt { type = nullOr str; };
			    psk = opt { type = str; };
			    keepAlive = opt { 
				type = nullOr int;
	    			default = null;
    			    };
			};
		    });
		};
	    };
	})
    };
    imports = [
	./env.nix
	./port.nix
    ];
    config = with import ./lib {inherit config lib;}; let
	## private vars
	cfg = config.net.wg-mesh;
	meshes = attrNames cfg;
	wg-meshes = filter (mesh: cfg.${mesh}.rosenpass == false) meshes;
	rp-meshes = filter (mesh: cfg.${mesh}.rosenpass == true) meshes;
	## global functions
	net.lib.getAddress = peers: peer:
	let 
	    ips = imap (i: v: "10.0.0.${builtins.toString i}") peers;
	    host-ips = map (x: { ${x.fst} = x.snd; } ) (zipLists peers ips);
	    peer-ip = head (filter (x: hasAttr ${peer} x) host-ips);
	in peer-ip.${peer};
	net.lib.mkTunnel = args@{...}: # dumb function, connects two peers
	let 
	    argsl = attrNames args;
	    peer = head (attrNames (filterAttrs (key: val: key != name) args));
	    peer-conf = args.${peer};
	in
	if !(hasAttr name args) then {} else
	if  (head argsl) == (tail argsl) then {}
	if  length argsl != 2 then {} else {
	    private = "/secrets/p2p-wg/${name}/private.key";
	    public = "/secrets/p2p-wg/${name}/public.key";
	    peers.${peer} = {
		fqdn = if nodes.${peer}.config.env.nat then null
		    else nodes.${peer}.config.networking.fqdn;
		keepAlive = if config.env.nat then 25 else null;
		psk = "/secrets/p2p-wg/${name}/psk/${peer}.psk.key";
		public = "/secrets/p2p-wg/${peer}/public.key";
		port = getPort "p2p-wg-${name}-${peer}";
	    } // peer-conf;
	};
	net.lib.mkMesh = args@{mesh,...}: # calls mkTunnel for every peer combination and
					  # updates peer config for a mesh scenario
	let 
	    peers = filterAttrs (key: val: key != "mesh") args;
	    peersl = attrNames peers;
	    args-ports = mapAttrs (peer: conf: { 
		port = getPort  
			(if nodes.${peer}.config.net.wg-mesh.${mesh}.rosenpass == true
			then "rp-mesh-${mesh}" else "wg-mesh-${mesh}");
		public = "/secrets/mesh/${mesh}/${peer}/public.key";
		private = "/secrets/mesh/${mesh}/${peer}/private.key";
	    } // conf) args;
	    eval = filter (x: x != {}) (unique (concatMap 
		(peer: map 
		    (peer2: if peer == peer2 then {} 
		    else {${peer} = args.${peer}; ${peer2} = args.${peer2};}) 
		peersl) 
	    peersl));
	    fcall = map (x: net.lib.mkTunnel x) eval;
	    res = zipAttrs (filter (x: x != {}) fcall);
	in  {
		${mesh} = {
		    peers = mapAttrs (key: val: head val) (zipAttrs res.peers);
		    private = head res.private;
		    public = head res.public;
		};
	    };# lets you override peer specific settings like this:
	      # net.wg-mesh = net.lib.mkMesh 
	      # let tracer = {port = 51280;} in
	      #		{mesh = "infra"; inherit tracer; }

    in mkIf (cfg != {}) mkMerge [{
	inherit (net.lib) # public functions
	    getAddress
	    mkTunnel
	    mkMesh;

	    services.bird2 = {
		config = ''
		    log syslog all;
		    protocol device {}
		    router id ${env.prim.v4};
		    protocol direct {
			interface ${concatMapStringsSep ", " (mesh: 
			    if mesh elem rp-meshes then "rp-${mesh}"
			    else "wg-${mesh}") meshes}
			    
		    }
		'';
	    };
	}
	++ map (mesh: (mkIf (config.vm != {}) 
	let
	    vms = filterAttrs (key: val: substring 0 3 ${key} == "vm-") cfg.${mesh}.peers;
	in {
	    microvm.vms = genAttrs vms (name: {
		config.net.wg-mesh.${mesh} = mkMesh 
		let
		    conf = {
			keepAlive = 25;
			fqdn = null;
			port = net.lib.getPort (if config.net.wg-mesh.${mesh}.rosenpass
			    then "rp-${mesh}" else "wg-${mesh}");
		    }; 
		in
		{inherit name mesh; ${name} = conf;} 
		// cfg.${mesh}.peers
		// ${cfg.${mesh}.self};
	    }) # handles mesh for VMs
	})) meshes
	++ # activates either rosenpass or plain wireguard for each mesh
	map (mesh: 
	    (mkIf cfg.${mesh}.rosenpass == false {
		systemd.network.netdevs = mapAttrs' (mesh: device: 
		    mesh = "wg-${mesh}"; 
		    device = {
			wireguardConfig = {
			    ListenPort = cfg.${mesh}.port
			};
			wireguardPeers = map (peer: with cfg.${mesh}.peers.${peer}; {
			    wireguardPeerConfig = {
				PersistentKeepAlive = keepAlive;
				PresharedKeyFile = ${psk};
				PublicKey = ${public};
				Endpoint = "${fqdn}:${toString port}";
				AllowedIPs = [
				    "${net.lib.getAddress cfg.${mesh}.peers peer}/32"
				];
			    };
			}) attrNames cfg.${mesh}.peers;
		    }) cfg;
	    })
	    //
	    (mkIf cfg.${mesh}.rosenpass == true {
		services.rosenpass = {
		    enable = true;
		    settings = {
			secret_key = cfg.${mesh}.public;
			public_key = cfg.${mesh}.public;
			listen = map (mesh: ${toString getPort "rp-${mesh}"}) rp-meshes;
			peers = map (mesh: mapAttrs (peer: conf: 
			    with cfg.${mesh}.peers.${peer}; {
				device = "rp-${mesh}";
				public_key = ${public};
				endpoint = ${fqdn}:${toString port}
			    }) cfg.${mesh}.peers) meshes;
		    };
		};
		environment.systemPackages = with pkgs; [
		    rosenpass
		    rosenpass-tools
		];
	    })
	) meshes;
}
# shellhook to generate public, private, and PSKs in sops for every host
# do BGP so two hosts behind two different NATs can connect
# sops
# extradevices for non nixos hosts
