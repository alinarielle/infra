{pkgs, config, lib, ...}: 
with lib; with builtins;
{
    options.l.boot.lanzaboote.enable = mkEnableOption "secure boot";
    config = mkIf config.l.boot.lanzaboote.enable {
	environment.systemPackages = [pkgs.sbctl];
	boot.loader.systemd-boot.enable = mkForce false;
	boot.lanzaboote = {
	    enable = true;
	    pkiBundle = "/etc/secureboot";
	};
    };
}
