{
  description = "alina's NixOS flake";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; 
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    colmena.url = "github:zhaofengli/colmena";
    nix-colors.url = "github:misterio77/nix-colors";
    hyprland.url = "github:spikespaz/hyprland-nix";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-hardware, colmena, nix-colors, hyprland, ... }: 
  let
	hostsDir = "${./.}/hosts";
	hostNames = with nixpkgs.lib; attrNames
      	    (filterAttrs (name: type: type == "directory") (builtins.readDir hostsDir));
  in
  {
    colmena = { 
      meta = {
        nixpkgs = import nixpkgs {
	  system = "x86_64-linux";
	  overlays = [];
	};
	specialArgs = { inherit inputs; };
      };
      defaults = { config, name, ... }: {
	imports = [
	  (./. + "/hosts/${name}")
	  home-manager.nixosModules.home-manager
	];
      };
    } // nixpkgs.lib.listToAttrs (map (name: nixpkgs.lib.nameValuePair name {}) hostNames);
    nixosConfigurations = ( colmena.lib.makeHive self.colmena ).nodes;
  };

#  system: let pkgs = nixpkgs.legacyPackages.${system}; in {
#    devShells.default = pkgs.mkShell {
#      name = "nixpkgs shell";
#      buildInputs = with pkgs; [
#        sops
#        nixfmt
#        colmena
#        ssh-to-age
#      ];
#    };
#  };
}
