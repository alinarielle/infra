{
  description = "alina's NixOS flake for lilium";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; 
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, nixos-hardware, ... }: {
    nixosConfigurations = {
      lilium = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
	  nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.alina = import ./hm-modules;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
