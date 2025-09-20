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
  ];
  l.profiles = enable [ "shell" ];
  system.stateVersion = "25.05";
  deployment.targetUser = "root";
  deployment.targetHost = "86.107.101.232";
}
