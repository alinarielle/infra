{config, inputs, ...}: with config.l.lib; {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./networking.nix
    ./hardware-configuration.nix
    ./disko.nix
  ];
  l.profiles = enable ["base" "hardened"];
  #l.filesystem.impermanence.enable = true;
  system.stateVersion = "25.05";
}
