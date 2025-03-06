{config, inputs, lib, ...}: with config.l.lib; {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./networking.nix
    ./hardware-configuration.nix
  ];
  l.profiles = enable ["base" "hardened"];
  #l.filesystem.impermanence.enable = true;
  l.network.unbound.enable = true;
  system.stateVersion = "25.05";
  deployment.targetHost = "162.55.172.244";
}
