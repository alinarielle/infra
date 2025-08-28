{config, inputs, lib, pkgs, ...}: with config.l.lib; {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];
  l.profiles = enable ["shell"];
  system.stateVersion = "25.05";
  l.services = {
    blog.enable = true;
    cv.enable = true;
    homepage.enable = true;
  };
  deployment.targetHost = "168.119.108.235";
}
