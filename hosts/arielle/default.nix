{ config, pkgs, inputs, lib, ... }: with config.l.lib; {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];
  l.profiles = enable ["desktop" "gaming"];
  #l.kernel.hardened.enable = true;
  system.stateVersion = "25.05";
  deployment.targetHost = "localhost";
}
