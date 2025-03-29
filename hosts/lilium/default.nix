{ config, pkgs, inputs, lib, ... }: with config.l.lib; {
  imports = [
    ./hardware-configuration.nix
  ];
  l.profiles = enable ["gaming" "desktop"];
  system.stateVersion = "23.11";
}
