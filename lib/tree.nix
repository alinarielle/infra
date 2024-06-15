{lib, config, ...}:
with lib; with builtins;
{
    lib.types.tree = {
	name = "Tree Data Structure";
	description = ''recursive struct used to store nested data'';
	descriptionClass = "nonRestrictiveClause";
	check = (x: isAttrs x);
	nestedTypes = {
	    path = mkOptionType {
		name = "Tree Path";
		description = ''part of a DSL for generating tree data structures,
				it selects a specific tree leaf/branch leave it empty 
				for the tree root, otherwise specify the branch-
				index to follow along the tree from left to right'';
		descriptionClass = "nonRestrictiveClause";
		check = (x:
		    all (y: 
			any (z: 
			    y == z) 
			    ["" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"]) 
			(splitString "" x)
		);
	    };
	};
    };
    lib.struct.mkTree = args@{
	public ? false, 
	meta ? false,
	symmetric ? false,
	name ? {str = "leaf-"; index = imap0;},
	adhoc ? {},
	check ? {},
	recurse ? {},
	strict_recurse ? {},
	update ? {},
	strict_update ? {},
	replace ? {},
	strict_replace ? {},
    }: 
    let
	argsl = attrNames args;
	collect_ops = args_collect@{...}:# assign ops to paths and sort them
	mapAttrs' (key: val:
	let
	    path = mapAttrs' (op: path: op = path) val;
	in
	) args;
	parse_paths = args_parse@{...}: mapAttrs ;
	eval = args_eval@{...}: 
	let
	    strict = args_strict@{...}: # asserts if all paths in a operation exist
	    if then "passed" else "failed";
	    adhoc = args_adhoc@{...}: # create paths with value x
	    ;
	    check = args_check@{...}: # assert condititions, supports path syntax
	    ;
	    recurse = args_recurse@{...}:# generate tree ranges recursively for value x
	    ;
	    replace = args_replace@{...}:# overwrite specific value
	    ;
	in;
	build_private_tree = args_build_priv@{...}:;
	build_public_tree = args_build_pub@{...}:;
	meta = {
	    paths = mapAttrs (key: val: ) args;
	    artifacts = map (key: ) argsl;
	};
	private_tree = ;
    in { 
	meta = mkIf args.meta meta;
    } // if args.public then public_tree else private_tree;
}
