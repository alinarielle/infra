{
    description = "alina's NixOS flake";
    inputs = {
	flake-parts.url = "github:hercules-ci/flake-parts";
	rnat.url = "gitlab:yuka/rnat?host=cyberchaos.dev";
	nix-dns.url = "github:kirelagin/dns.nix";
	lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
	lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
	nixos-hardware.url = "github:NixOS/nixos-hardware/master"; 
	nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	nixpkgs-2405.url = "github:nixos/nixpkgs/nixos-24.05";
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
	lix.url = 
	    "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.90-beta.1";
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
	    url = "github:sodiboo/niri-flake";
	    inputs.nixpkgs.follows = "nixpkgs";
	};
	stylix.url = "github:danth/stylix";
	disko.url = "github:nix-community/disko";
	disko.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
	imports = [
	    ./colmena.nix
	    ./lib.nix
	];
	systems = ["x86_64-linux"];
    };
}
