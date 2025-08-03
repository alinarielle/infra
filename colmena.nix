{ inputs, lib, self, name,  ... }: let
    hostsDir = "${./.}/hosts";
    hostNames = with lib; attrNames
	(filterAttrs (name: type: type == "directory") (builtins.readDir hostsDir));
    colmena = inputs.colmena;
in {
    flake.colmena = {
	meta = rec {
	    nixpkgs = import inputs.nixpkgs {
		system = "x86_64-linux";
		overlays = [ (import inputs.emacs-overlay) ];
	    };
	    specialArgs = { inherit inputs; };
	};
	defaults = { config, name, nodes, ... }: let
	  mkLocalMods = import ./lib/mkLocalMods.nix {inherit lib name;};
	in {
	    imports = [
        inputs.niri.nixosModules.niri
        inputs.home-manager.nixosModules.home-manager
        (./. + "/hosts/${name}")
        ./lib
        ./rclone2.nix
        (mkLocalMods {prefix = ["l"]; dir = ./modules;})
        inputs.sops-nix.nixosModules.sops
	    ];
	    deployment = lib.mkDefault {
		targetUser = "root";
		allowLocalDeployment = true;
	    };
	};
    } // lib.listToAttrs (map
	(name: lib.nameValuePair name {})
	hostNames
    );
    flake.nixosConfigurations = ( colmena.lib.makeHive self.colmena ).nodes;
}

