{
  inputs = {
    sops.url = "git+ssh://git@codeberg.org/alinarielle/fops.git";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    # quickshell = {
    #   url = "github:outfoxxed/quickshell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    linuxStable = {
      flake = false;
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git";
    };
    rclone.url = "git+ssh://git@codeberg.org/alinarielle/rclone.nix.git";
    nix-topology.url = "github:oddlama/nix-topology";
    flake-parts.url = "github:hercules-ci/flake-parts";
    dns.url = "github:kirelagin/dns.nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    colmena.url = "github:zhaofengli/colmena";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
    nix-colors.url = "github:misterio77/nix-colors";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    niri.url = "github:sodiboo/niri-flake";
    # rust-toolchain = {
    #   url = "git+ssh://git@codeberg.org/alinarielle/rust-toolchain.git";
    # };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./lib/colmena.nix
        ./lib/shell.nix
        ./lib/fmt.nix
        ./lib/app.nix
      ]
      ++ [
        inputs.nix-topology.flakeModule
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
}
