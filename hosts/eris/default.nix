{config, inputs, lib, ...}: with config.l.lib; {
  imports = [
    ./networking.nix
    ./hardware-configuration.nix
  ];
  l.profiles = enable ["base" "hardened"];
  system.stateVersion = "25.05";
  deployment.targetHost = "162.55.172.244";
}
