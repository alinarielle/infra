{lib, config, name, ...}:
with lib; with builtins;
let 
    cfg = config.ceph;
    opt = mkOption;
in {
    options.ceph = with types; {
	nodes = opt { type = attrs; default = {}; };
	name = opt { type = str; default = "ceph"; };
	isClient = opt { type = bool; default = false; };
	isServer = opt { type = bool; default = false; };
	isMDS = opt { type = bool; default = false; };
    };
    config =
    let
	mkCephCluster = args@{cluster, ...}:
	let
	    nodel = attrNames (filterAttrs (key: val: key != "cluster") args);
	in
	=> data modelling to opt struct;
    in
    mkIf (cfg != {}) {
	services.ceph = {
	    global = {
		clusterName = cfg.name;
	    };
	};
    };
}
