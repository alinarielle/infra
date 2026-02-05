{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with config.l.lib;
{
  # sops.enable = lib.mkForce false;
  imports = [
    ./disko.nix
  ];
  l.profiles = enable [
    "shell"
  ];
  system.stateVersion = "26.05";
  deployment.targetHost = "localhost";
}
