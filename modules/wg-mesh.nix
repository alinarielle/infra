{config, nodes, lib, pkgs, name, ...}:
let 
    cfg = config.net.wg-mesh;
in {
    options.net.wg-mesh = lib.mkOption {
	default = {};
	type = lib.types.attrsOf (lib.types.submodule {
	    options.peers = lib.mkOption {
	    default = {};
	        type = lib.types.attrsOf (lib.types.submodule {
		    options = {
			fqdn = lib.mkOption {
			    type = lib.types.str;
			    description = "specifies how to reach the peer"
			};
			port = lib.mkOption {
			    type = lib.types.int;
			    default = 51280;
			    example = 1337;
			};
			psk = lib.mkOption {
			    type = lib.types.nullOr lib.types.attrsOf lib.types.str;
			    default = null;
			    description = "base64 encoded pre-shared symmetric key";
			    example = {
				host_a-b = "asjdlksalkjdsa";
				host_a-c = "aaslkjdsadlkjs";
			    };
			};
			privateKey = lib.mkOption {
			    type = lib.types.nullOr lib.types.str;
			    default = null;
			};
			publicKey = lib.mkOption {
			    type = lib.types.nullOr lib.types.str;
			    default = null;
			};
			peerType = lib.mkOption {
			    type = lib.types.str;
			    example = "site";
			    default = "nat";
			};
		    };
	        })
	   };
        })
    };
    config = with lib;
    let
	meshes = builtins.attrNames cfg;
	peers = builtins.attrNames cfg.${meshes}.peers;
    in
    lib.mkIf (cfg != {}) {
	net.wg-mesh = genAttrs meshes (mesh:
	    genAttrs peers (peer: 
		{ 
		    ${mesh}.peers.${peer} = {
			fqdn = nodes.${peer}.config.networking.fqdn;
			privateKey = #pathToSops
		    };
		}
	    )
	);
	services.rosenpass = {
	    enable = true;
	    settings = {
		listen = 
		let applicable_meshes = filter (mesh: hasAttr name cfg.${mesh}.peers) meshes;
		in mkIf (any (mesh: cfg.${mesh}.peers.${name}.peerType == "site") applicable_meshes) [ "0.0.0.0:10000" ];
	    };
	};
    };
}
#TODO: check for clashes when a peer doesn't exist in every mesh and will still be generated, also find a way to include VMs because their configs aren't passed as colmena `nodes`
# generate PSKs, public and private keys automatically
