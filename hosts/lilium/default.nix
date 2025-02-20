{ config, pkgs, inputs, lib, ... }: with config.l.lib; {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
  ];
    
  l.profiles = enable ["base" "hardened"];
  l.desktop.sway = enable ["config" "swaylock" "waybar"];
  l.kernel.hardenedLibre.enable = lib.mkForce false;
  system.stateVersion = "23.11";
  deployment.tags = ["hidpi" "desktop"];

  # audio fix
  boot.kernelParams = [ "snd-intel-dspcfg.dsp_driver=1" "i8042.debug" "i8042.nopnp"];
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';
  environment.systemPackages = with pkgs; [
    sof-firmware
    alsa-ucm-conf
    alsa-utils
  ];
  l.services.test.enable = false;
  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;
}
