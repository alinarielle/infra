{config, nodes, lib, pkgs, name, ...}:
with lib; with builtins;
let
    cfg = config.l.network.mesh;
    opt = mkOption;
in {
    options.l.network.mesh = with types; opt {
	default = {};
	type = attrsOf (submodule {
	    options = {
		rosenpass = opt { default = true; type = bool; };
		port = opt { type = port; };
		privateKeyFile = opt { type = str; };
		publicKeyFile = opt { type = str; };
		fqdn = opt { default = networking.fqdn; type = str; };
		peers = opt {
		    default = {};
		    type = attrsOf (submodule {
			options = {
			    port = opt { type = port};
			    privateKeyFile = opt { type = str; };
			    publicKeyFile = opt { type = str; };
			    fqdn = opt { type = str; };
			    pskFile = opt { type = str; };
			    keepAlive = opt {
				type = nullOr int;
				default = null;
			    };
			};
		    });
		};
	    };
	});
    };
    config = mkMerge [{
	lib.network.mkTunnel = args@{...}:
	let
	    argsl = attrNames args;
	    peer = head (filter (uwu: ${uwu} == name) argsl);
	    peerOverride = args.${peer};
	    selfOverride = args.${name};
	in
	    mkIf ((config.lib.cuddlepiles.validate args) && (length argsl == 2 )) {
		privateKeyFile = 
		    "/secrets/${name}/network/tunnel/${peer}/wireguard/private.key";
		publicKeyFile = 
		    "/secrets/${name}/network/tunnel/${peer}/wireguard/public.key";
		pskFile =
		    "/secrets/${name}/network/tunnel/${peer}/wireguard/psk.key";
		port = lib.network.getPort "wg-${name}-${peer}";
		keepAlive = mkIf config.environment.network.isBehindNAT 25;
		peers.${peer} = with nodes.${peer}.config.l.environment.network; {
		    fqdn = mkIf !(isBehindNAT)
			if (fqdn != "") && (fqdn != null) then fqdn else
			if ipAddresses.any.primary != null then ipAddresses.any.primary
			else null;
		    keepAlive = mkIf isBehindNAT 25;
		    port = lib.network.getPort "wg-${peer}-${name}";
		    publicKeyFile = 
			"/secrets/${peer}/network/tunnel/${name}/wireguard/public.key";
		    pskFile = 
			"/secrets/${peer}/network/tunnel/${name}/wireguard/psk.key";
		} // peerOverride;
	    } // selfOverride;
	lib.network.mkMesh = args@{...}:
	let
	    argsl = attrNames args;
	in
	;
    }];
}
