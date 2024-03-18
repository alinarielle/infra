{ config, lib, pkgs, inputs, ... }: {
    imports = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./hardware-configuration.nix
      ../../profiles/desktop
      ../../common
    ];

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices.main.device = "/dev/disk/by-uuid/e1743e69-f6f7-4497-895f-7b5bc2fa5ef0";
  boot.kernelParams = [ "snd-intel-dspcfg.dsp_driver=1"];
  boot.extraModprobeConfig = ''
  options snd-intel-dspcfg dsp_driver=1
'';

  networking.hostName = "lilium";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";

  programs.steam.enable = true;
    environment.systemPackages = with pkgs; [
	sof-firmware
	alsa-ucm-conf
	alsa-utils
    ];
   system.stateVersion = "23.11";
   deployment = {
	targetHost = "null";
	targetUser = "alina";
	allowLocalDeployment = true;
   };

   #l.hidpi = true;
}
