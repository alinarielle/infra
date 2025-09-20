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
}
