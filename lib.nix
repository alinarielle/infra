{lib, config, ...}: let
    /*load = base: default: builtins.readDir base
	|> lib.filterAttrs (name: type: builtins.match "(regular|directory)" type != null)
	|> lib.mapAttrs' (name: type: {
	    name = if type == "regular" then lib.removeSuffix ".nix" name else name;
	    value = let
		path = if type == "directory" then "${name}/${default}.nix" else name;
	    in import "${base}/${path}" inputs;
	}); my nix doesnt have the pipe operator yet qwq*/
in {
    flake.lib = /* load ./lib "lib" // {
	inherit load;
    }; */ {
	modules = import ./lib/mkLocalModule.nix {inherit lib config;};
    };
}
