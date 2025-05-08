{ config, pkgs, inputs, lib, ... }: with config.l.lib; {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];
  l.profiles = enable ["desktop"];
  system.stateVersion = "25.05";
}
