{
  config,
  inputs,
  lib,
  ...
}:
with config.l.lib;
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];
  l.profiles = enable [ "shell" ];
  system.stateVersion = "25.05";
  deployment.targetUser = "root";
  deployment.targetHost = "91.99.217.113";
}
