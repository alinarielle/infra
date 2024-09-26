{ inputs, lib, self, ... }: let
    hostsDir = "${./.}/hosts";
    hostNames = with lib; attrNames
	(filterAttrs (name: type: type == "directory") (builtins.readDir hostsDir));
    colmena = inputs.colmena;
in {
    flake.colmena = {
	meta = rec {
	    nixpkgs = import inputs.nixpkgs {
		system = "x86_64-linux";
		overlays = [
		    inputs.niri.overlays.niri
		];
	    };
	    specialArgs = { inherit inputs self; };
	};
	defaults = { config, name, nodes, ... }: {
	    imports = [
		inputs.home-manager.nixosModules.home-manager
		(./. + "/hosts/${name}")
		./boot
		./deployment
		./desktop
		./filesystem
		./meta
		./network
		./packages
		./users
	    ];
	};
    } // lib.listToAttrs (map
	(name: lib.nameValuePair name {})
	hostNames
    );
    flake.nixosConfigurations = ( colmena.lib.makeHive self.colmena ).nodes;
}

