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
  deployment.targetHost = "v2202509299447386038.hotsrv.de";
}
