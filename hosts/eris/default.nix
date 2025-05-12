{config, inputs, lib, ...}: with config.l.lib; {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];
  l.profiles = enable ["shell"];
  system.stateVersion = "25.05";
  l.services.cv.enable = true;
  deployment.targetHost = "168.119.108.235";
}
