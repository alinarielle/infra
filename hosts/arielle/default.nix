{
  config,
  pkgs,
  inputs,
  lib,
  modulesPath,
  ...
}:
with config.l.lib;
{
  imports = [
    # ./disko.nix
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-12-13th-gen-intel
  ];
  l.profiles = enable [
    "desktop"
    "gaming"
    "laptop"
  ];
  system.stateVersion = "25.05";
  deployment.targetHost = "localhost";
}
