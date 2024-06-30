{
  description = "alina's NixOS flake";

  inputs = {
    nix-dns.url = "github:kirelagin/dns.nix";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; 
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    colmena.url = "github:zhaofengli/colmena";
    nix-colors.url = "github:misterio77/nix-colors";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-git.url = "github:hyprwm/hyprland/main";
    hyprland-xdph-git.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    hyprland-protocols-git.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    lix.url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
    lix.flake = false;
    lix-module = {
	url = "git+https://git.lix.systems/lix-project/nixos-module";
	inputs.lix.follows = "lix";
	inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
	url = "github:spikespaz/hyprland-nix";
	inputs = {
	    hyprland.follows = "hyprland-git";
	    hyprland-xdph.follows = "hyprland-xdph-git";
	    hyprland-protocols.follows = "hyprland-protocols-git";
	};
    };
    niri = {
	url = "github:YaLTeR/niri";
	inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-hardware, colmena, nix-colors, hyprland, nixvim, sops-nix, impermanence, flake-utils, microvm, nix-dns, lix-module, niri, stylix, lanzaboote, ... }: 
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
	  overlays = [ niri.overlays.niri ];
	};
	specialArgs = { inherit inputs; };
      };
      defaults = { config, name, nodes, ... }: {
	imports = [
	  (./. + "/hosts/${name}")
	  inputs.home-manager.nixosModules.home-manager
	  inputs.sops-nix.nixosModules.sops
	  inputs.impermanence.nixosModules.impermanence
	  inputs.lix-module.nixosModules.default
	  inputs.niri.nixosModules.niri
	  inputs.stylix.nixosModules.stylix
	  inputs.lanzaboote.nixosModules.lanzaboote
	  ./boot
	  ./deployment
	  ./desktop
	  ./filesystem
	  ./kernel
	  ./lib
	  ./meta
	  ./network
	  ./packages
	  ./services
	  ./tasks
	  ./users
	];
	nix = {
	    settings = {
		experimental-features = [ "nix-command" "flakes" ];
		trusted-users = [ "@wheel" "root" ];
	    };
	    config = {
		auto-optimise-store = true;
	    };
	    gc = {
		automatic = true;
		options = "--delete-older-than 7d";
	    };
	    package = inputs.nixpkgs.lix;
	};
	time.timeZone = inputs.nixpkgs.lib.mkDefault "Europe/Berlin";
	networking.hostName = with nixpkgs.lib; mkDefault name;
	networking.domain = with nixpkgs.lib; mkDefault "infra.alina.cx";
      };
    } // nixpkgs.lib.listToAttrs (map (name: nixpkgs.lib.nameValuePair name {}) hostNames);
    nixosConfigurations = ( colmena.lib.makeHive self.colmena ).nodes;
  } // flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {
	inherit system;
	overlays = [];
    };
    in {
	#devShells.default = pkgs.mkShell {
	    #name = "flake";
	    #buildInputs = with pkgs; [
		#nixfmt
		#ssh-to-age
		#just
		#sops
	    #] ++ [ inputs.colmena.packages.${system}.colmena ];
	    #shellhook = ''
		#just -l
	    #'';
	#};
    });
}
