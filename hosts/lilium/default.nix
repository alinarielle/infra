{ config, pkgs, inputs, lib, ... }: with config.l.lib; {
  imports = [
    ./hardware-configuration.nix
  ];
  l.profiles = enable ["workstation"];
  system.stateVersion = "23.11";
}
