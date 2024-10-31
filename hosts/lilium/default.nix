{ config, pkgs, inputs, ... }: with config.l.lib; {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
  ];
    
  l.profiles = enable ["base" "hardened"];
  l.desktop.sway = enable ["config" "swaylock" "waybar"];

  system.stateVersion = "23.11";
  deployment.tags = ["hidpi" "desktop"];
}
