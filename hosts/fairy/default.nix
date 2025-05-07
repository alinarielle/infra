{ config, pkgs, inputs, lib, ... }: with config.l.lib; {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];
  l.profiles = enable ["desktop"];
  system.stateVersion = "25.05";
}
