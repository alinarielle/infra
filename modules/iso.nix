{inputs, pkgs, config, ...}: {
  # imports = [
  #   (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/iso-image.nix")
  # ];
  # environment.systemPackages = with pkgs; [
  #   (pkgs.writeShellScriptBin "buildImage" ''
  #       nix build ~/src/infra#nixosConfigurations.arielle.config.system.build.isoImage
  #   '')
  # ];
}
