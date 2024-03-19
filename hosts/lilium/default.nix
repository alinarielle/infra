{ config, lib, pkgs, inputs, ... }: {
    imports = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./hardware-configuration.nix
      ../../profiles/desktop
      ../../common
    ];

  nixpkgs.config.allowUnfree = true;
  boot.kernelParams = [ "snd-intel-dspcfg.dsp_driver=1"];
  boot.extraModprobeConfig = ''
  options snd-intel-dspcfg dsp_driver=1
'';

    environment.systemPackages = with pkgs; [
	sof-firmware
	alsa-ucm-conf
	alsa-utils
    ];
    networking.hostName = "lilium";
    programs.steam.enable = true;
    system.stateVersion = "23.11";
    deployment = {
	targetHost = "lilium.infra.alina.cx";
	targetUser = "alina";
	allowLocalDeployment = true;
	tags = [ "infra" "desktop" ];
    };

   #l.hidpi = true;
}
