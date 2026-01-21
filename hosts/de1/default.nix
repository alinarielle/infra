{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with config.l.lib;
{

  imports = [
    ./disko.nix
    # ./hardware-configuration.nix
  ];
  l.profiles = enable [
    "shell"
  ];
  system.stateVersion = "26.05";
  deployment.targetHost = "de1.net.alina.dog";
}
