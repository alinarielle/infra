{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with config.l.lib;
{
  l.profiles = enable [
    "shell"
  ];
  imports = [
    ./disko.nix
  ];
  system.stateVersion = "26.05";
  deployment.targetHost = "de1.net.alina.dog";
}
