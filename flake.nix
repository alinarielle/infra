{
    description = "alina's NixOS flake";
    inputs = {
	linuxStable = {
	    flake = false;
	    url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
	};
	flake-parts.url = "github:hercules-ci/flake-parts";
	rnat.url = "gitlab:yuka/rnat?host=cyberchaos.dev";
	nix-dns.url = "github:kirelagin/dns.nix";
	nixos-hardware.url = "github:NixOS/nixos-hardware/master"; 
	nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	flake-utils.url = "github:numtide/flake-utils";
	home-manager.url = "github:nix-community/home-manager";
	home-manager.inputs.nixpkgs.follows = "nixpkgs";
	colmena.url = "github:zhaofengli/colmena";
	nixvim.url = "github:nix-community/nixvim";
	nixvim.inputs.nixpkgs.follows = "nixpkgs";
	sops-nix.url = "github:Mic92/sops-nix";
	impermanence.url = "github:nix-community/impermanence";
	microvm.url = "github:astro/microvm.nix";
	microvm.inputs.nixpkgs.follows = "nixpkgs";
	nix-colors.url = "github:misterio77/nix-colors";
	emacs-overlay.url = "github:nix-community/emacs-overlay";
	lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
	lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
	disko.url = "github:nix-community/disko/latest";
	disko.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
	imports = [
	    ./colmena.nix
	];
	systems = ["x86_64-linux"];
    };
}
