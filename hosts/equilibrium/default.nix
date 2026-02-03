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
  deployment.targetHost = "equilibrium.net.alina.dog";
}
