{lib, config, ...}:
with lib; with builtins; 
let
    opt = mkOption;
in
    priv_tree_struct = args@{...}: ;
    opt_tree_struct = args@{...}: mkOption;

# default = {}; for all layers, description = layer count
# being able to stop the recursing after <n> layers for different branches, else recurse infinitely
# smart way to specify which branch span to copy, one layer per default
# ability to choose name of leaves
# ability to update certain layers with custom attrs
# ability to pass variables for mkEnabledOption
# ability to pass generated values, corresponding to the current layer
# store current path... in option description?
# ability to request tree with path info
# recursive Options?
# ability to specify pattern to be copied/recursed, also in JSON
# (some) verbs can be used recursively in DSL
# meta is a list of update operations to execute on the tree to gradually build it
    tree = priv_tree {
	adhoc = {
	    "0101" = { foo = "bar";}; # explicitely generate the attrs at the spec. path
	};
	recurse = [
	    { from = "010"; to = "0101110"; };
	];
	or
	recurse {foo} from "010" to "0101110"; other keywords: root, infinity
	name = {str = <func> ? leaf-; index = <func> ? imap0;};
	check # assertions but for the given struct config and path syntax
	update = {
	    "010" = { foo = "bar"; }; 	# use // operator on the attrs at path 010 
					# with {foo = "bar";}; on the r side
					# creates the path and attrs if it doesnt exist
					# updates have priorities
	};
	strict_update = {
	    # same as update, but throws an error if the path doesnt exist
	};
	replace = {
	    # overwrites an attrs entirely
	};
	strict_replace # same as strict_update
	meta = true; # bool whether meta data is exposed or private
	public = true; # bool whether to return options or a private struct
    }
    tree = pub_tree {} => opt {
	description = "root";
        type = attrsOf (submodule {
	    options = {
		leaf-0 = {
		    description = "0";
		};
		leaf-1 = {
		    description = "1";
		    leaf 
		    leaf-1 = {
			description = "10";
			leaf-0
			leaf-1
			leaf-2
			leaf-3 = { description = "103";};
		    };
		};
	    };
	})
    };
}
