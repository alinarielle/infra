{config, inputs, lib, ...}: with config.l.lib; {
  imports = [
    ./networking.nix
    ./hardware-configuration.nix
  ];
  l.profiles = enable ["shell"];
  system.stateVersion = "25.05";
  deployment.targetHost = "162.55.172.244";
  l.services.pretalx.enable = true;
}
