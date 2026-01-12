{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with config.l.lib;
{

  l.virtualization.libvirtd.enable = true;
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
  system.stateVersion = "25.05";
  deployment.targetHost = "localhost";
}
