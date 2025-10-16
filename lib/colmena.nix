{
  inputs,
  lib,
  self,
  name,
  ...
}:
let
  modsDir = ../modules;
  hostsDir = "${./../hosts}";
  hostNames =
    with lib;
    attrNames (filterAttrs (name: type: (type == "directory") && (name != "lib")) (builtins.readDir hostsDir));
  colmena = inputs.colmena;
in
{
  flake.colmena = {
    meta = rec {
      nixpkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        overlays = [ (import inputs.emacs-overlay) ];
      };
      specialArgs = { inherit inputs; };
    };
    defaults =
      {
        config,
        name,
        nodes,
        self,
        ...
      }:
      let
        mkLocalMods = import ./mkLocalMods.nix {
          inherit lib name;
        };
      in
      {
        imports = [
          inputs.home-manager.nixosModules.home-manager
          (./../hosts + "/${name}")

          ./.
          (mkLocalMods {
            prefix = [ "l" ];
            dir = modsDir;
          })
          inputs.sops-nix.nixosModules.sops
        ];
        deployment = lib.mkDefault {
          targetUser = "root";
          allowLocalDeployment = true;
        };
      };
  }
  // lib.listToAttrs (map (name: lib.nameValuePair name { }) hostNames);
  flake.nixosConfigurations = (colmena.lib.makeHive self.colmena).nodes;
}
