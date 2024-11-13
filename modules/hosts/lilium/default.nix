{ config, pkgs, inputs, lib, ... }: with config.l.lib; {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
  ];
    
  l.profiles = enable ["base" "hardened"];
  l.kernel.hardened.enable = lib.mkForce false; # laptop depends on proprietary wifi firmware
  l.desktop.sway = enable ["config" "swaylock" "waybar"];
  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.11";
  deployment.tags = ["hidpi" "desktop"];
}
