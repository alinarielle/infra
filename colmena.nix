{ inputs, lib, self, ... }: let
    hostsDir = "${./.}/modules/hosts";
    hostNames = with lib; attrNames
	(filterAttrs (name: type: type == "directory") (builtins.readDir hostsDir));
    colmena = inputs.colmena;
    mkLocalMods = import ./lib/mkLocalMods.nix {inherit lib;};
in {
    flake.colmena = {
	meta = rec {
	    nixpkgs = import inputs.nixpkgs {
		system = "x86_64-linux";
		overlays = [
		    inputs.niri.overlays.niri
		];
	    };
	    specialArgs = { inherit inputs; };
	};
	defaults = { config, name, nodes, ... }: {
	    imports = [
		inputs.home-manager.nixosModules.home-manager
		(./. + "/modules/hosts/${name}")
		./lib
		(mkLocalMods {prefix = ["l"]; dir = ./modules;})
	    ];
	    deployment = lib.mkDefault {
		targetUser = "alina";
		allowLocalDeployment = true;
	    };
	};
    } // lib.listToAttrs (map
	(name: lib.nameValuePair name {})
	hostNames
    );
    flake.nixosConfigurations = ( colmena.lib.makeHive self.colmena ).nodes;
}

