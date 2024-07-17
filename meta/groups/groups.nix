{lib, config, nodes, name, ...}:
with lib; with builtins;
let
    cfg = config.l.meta.cuddlepiles;
    opt = mkOption;
in {
    options.l.meta.cuddlepiles = with types; opt {
	default = {};
	type = attrsOf (submodule {
	    options = {
		limited = {
		    appendOnly = {
			receiver = opt { type = listOf host; default = []; };
			sender = opt { type = listOf host; default = []; };
		    };
		};
		vlan = opt { default = false; type = bool; };
		rp-mesh = opt { default = true; type = bool; };
		wg-mesh = opt { default = false; tupe = bool; };
		peers = opt {
		    default = {};
		    type = attrsOf (submodule {
			options = {
			    cuddle = mkEnableOption "cuddle";
			    meows = opt {
				default = {};
				type = attrs;
			    };
			};
		    });
		};
	    };
	});
    };
    config = {
	lib.cuddlepiles.validate = args@{...}:
	let
	    argsl = attrNames args;
	    nodesl = attrNames nodes;
	in
	if !(allUnique argsl) then false else 	# return empty if the same host 
						# was specified more than once
	if !(hasAttr name args) then false else # return empty if the 
						# current host is not mentioned
	true;
    };
}
