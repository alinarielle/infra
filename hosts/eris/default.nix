{config, inputs, ...}: with config.l.lib; {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./networking.nix
    ./hardware-configuration.nix
  ];
  l.profiles = enable ["base" "hardened"];
  system.stateVersion = "25.05";
}
