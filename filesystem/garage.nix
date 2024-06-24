{lib, config, name, ...}: 
with lib;
with builtins;
let 
    cfg = config.s3;
    opt = lib.mkOption; 
in {
    options.s3 = with types; {
	nodes = opt {
	    type = attrs;
	};
    };
    imports = [
	./env.nix
	./port.nix
	./backup.nix
	./wg-mesh.nix
    ];
    config = with import ../lib {inherit config lib;};
    let
	nodl = attrNames cfg.nodes;
	mkNode = node-list:
	let
	    
	in # return attrs with node ids if possible and put nodes in declared structure
	# if list does not include self, abort executing config block
	# how are node ids calculated? can i just freely choose them?
	;
    in mkIf elem name nodl{
	inherit getPort; inherit (net.lib) mkMesh;
	environment.systemPackages = with pkgs; [
	    garage
	];
	services.garage = {
	    enable = true;
	    logLeve = "info";
	    extraEnvironment = {
		GARAGE_LOG_TO_SYSLOG = true;
	    };
	    settings = {
		replication_factor = 3;
		consistency_mode = "consistent";
		metadata_dir = "/var/lib/garage/meta"; #bind => /meta_s3
		data_dir = "/var/lib/garage/data"; # bind => /s3
		#bind => /hdd/s3/data
		# cache frequently accessed objects on SSD
		db_engine = "sqlite";
		metadata_fsync = if (length (attrNames cfg.nodes) <= 1
		    then true else false);
		data_fsync = if (length (attrNames cfg.nodes)) <= 1 
		    then true else false;
		disable_scrub = false;
		block_size = "10M";
		block_ram_buffer_max = config.env.ram.alloc.garage.block_ram_buffer_max;
		lmdb_map_size = "1TiB";
		compression_level = 5;
		rpc_secret_file = "/secrets/s3/rpc.private";
		rpc_bind_addr = ''[::]:${toString getPort "s3"}'';
		rpc_bind_outgoing = true;
		rpc_public_addr = config.env.ip.s3.v6 + ":" + toString getPort "s3";
		bootstrap_peers = map (node: with nodes.${node}.config; 
		    env.pgp.s3-public + "@" networking.fqdn + ":" + toString getPort "s3")
			(attrNames nodes);
		allow_world_readable_secrets = false;
		s3_api = {
		    api_bind_addr = "[::]:" + toString getPort "s3-api";
		    s3_region = "s3";
		    root_domain = "s3.alina.cx";
		};
		admin = {
		    api_bind_addr = "[::]:" + toString getPort "s3-admin";
		    metrics_token_file = "/secrets/${name}/s3/metrics_token";
		    admin_token_file = "/secrets/${name}/s3/admin_token";
		    trace_sink = "http://localhost:" + toString getPort "s3-admin";
		};
	    };
	};
	backups.paths = [${config.garage.settings.metadata_dir}];
	#TODO persistance
	environment.persistence = 
	net.wg-mesh.s3 = net.lib.mkMesh {
	    rosenpass = true;
	    mesh = "s3";
	} // cfg.nodes;
	systemd.services.garage = {
	    description = "garage s3 init";
	    wants = ["network-online.target"];
	    after = ["network-online.target"];
	    wantedBy = ["multi-user.target"];
	    confinement.enable = true;
	    environment = {
		TOKEN_PATH = config.services.garage.settings.admin.admin_token_file;
		PORT = toString getPort "s3-admin";
	    };
	    serviceConfig = {
		DynamicUser = true;
		StateDirectory = "garage";
		ProtectHome = true;
		NoNewPrivileges = true;
		LoadCredential = "admin_token:" + 
		    config.services.garage.settings.admin.admin_token_file;
		ExecStart = "${lib.getExe pkgs.garage} server";
	    };
	    path = with pkgs; [
		bash
		garage
		curl
		jq
	    ];
	    postStart = let 
		query = "'.[node]'"; 
		port = toString getPort "s3-admin";
	    in ''
		#!/bin/bash
		set -eou pipefail
		garage node id
		export TOKEN=$(cat admin_token)
		${concatMapStringsSep "\n" (node: toString (
		curl -H Authorization: Bearer $TOKEN 
		https://s3.${node}.infra.alina.cx:${port}/v1/status | 
		jq ${query} ''\> ${node}-id;
		garage node connect 
		$(cat ${node}-id)@https://s3.${node}.infra.alina.cx:${port}))
		    nodl}
	    '';# curl node id from every node and create layout table
	    
	};
    };
}
