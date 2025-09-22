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
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-12-13th-gen-intel
  ];
  l.profiles = enable [
    "desktop"
    "gaming"
    "laptop"
  ];
  #l.kernel.hardened.enable = true;
  system.stateVersion = "25.05";
  deployment.targetHost = "localhost";
}
