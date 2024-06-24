{lib, config, name ? config.networking.hostname, nodes,...}:
with lib; with builtins;
let 
    cfg = config.ceph;
    opt = mkOption;
    tree_struct = with types; args@{...}: 
    let
	counter = imap0 (int: val: ) attrNames args);
    in opt {
	default = {};
	type = attrsOf (submodule {
	    options = {
		enable = mkEnableOption head (attrNames args);
	    };
	});
	nodes = opt { type = attrsOf submodule; default = {}; };
    };
in {
    options.ceph = with types; opt {
	default = {};
	type = (attrsOf submodule {
	    enable = mkEnableOption "ceph";
	    nodes = opt { type = attrsOf attrs; default = {}; };
	    rbd = { 
		enable = mkEnableOption "RADOS Block Device";
		nodes = opt { type = attrsOf attrs; default = {};};
	    };
	    rgw = {
		enable = mkEnableOption "RADOS S3 Gateway";
		nodes = opt { type = attrsOf attrs; default = {}; };
	    };
	    fs = {
		enable = mkEnableOption "Ceph Filesystem";
		nodes = opt { type = attrsOf attrs; default = {}; };
	    };
	});

    config = let
	mkCephNode = args@{...}:
	
	mkCephCluster = args@{cluster, ...}:
	let
	    nodel = attrNames (filterAttrs (key: val: key != "cluster") args);
	in
	=> data modelling to opt struct;
    in mkIf (cfg != {}) {
	ceph = genAttrs ["rgw" "rbd" "fs"] (interface: 
	    ${interface}.nodes = genAttrs 
		(filter 
		    (x: nodes.${x}.config.ceph.${interface}.enable && x != name) 
		    (attrNames nodes))
		(node: ${node} = nodes.${node}.config.ceph.${interface});
	    );

	services.ceph = {
	    global = {
		clusterName = cfg.name;
	    };
	    rgw = {
		enable = cfg.
	    };
	};
    };
}
