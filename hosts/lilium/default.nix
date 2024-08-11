{ config, lib, pkgs, inputs, ... }: with lib.meta; {
    imports = [
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./hardware-configuration.nix
    ];

    system.stateVersion = "23.11";
    l.profiles = enable ["base"];
    l.desktop = enable ["sway"];

    # broken keyboard fix
    boot.kernelParams = [ "snd-intel-dspcfg.dsp_driver=1" "i8042.debug" "i8042.nopnp"];
    boot.extraModprobeConfig = ''
	options snd-intel-dspcfg dsp_driver=1
    '';

    # broken audio fix
    environment.systemPackages = with pkgs; [
	sof-firmware
	alsa-ucm-conf
	alsa-utils
    ];

}
