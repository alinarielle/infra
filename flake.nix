{
  inputs = {
    fops.url = "/bites/src/fops";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    linux = {
      flake = false;
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    openbsd = {
      flake = false;
      url = "https://github.com/openbsd/src";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rclone.url = "https://codeberg.org/alinarielle/rclone.nix/archive/mistress.tar.gz";
    nix-topology.url = "github:oddlama/nix-topology";
    flake-parts.url = "github:hercules-ci/flake-parts";
    dns.url = "github:kirelagin/dns.nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    colmena.url = "github:zhaofengli/colmena";
    impermanence.url = "github:nix-community/impermanence";
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./lib/colmena.nix
        ./lib/shell.nix
        ./lib/fmt.nix
        ./lib/app.nix
        inputs.nix-topology.flakeModule
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
}
