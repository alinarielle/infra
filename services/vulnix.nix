{lib, pkgs, ...}:
{
    systemd.services.vulnix = {
	enable = true;
	wants = [ "networking.target" ];
	wantedBy = [ "multi-user.target" "timers.target" ];
	confinement.enable = true;
	serviceConfig = {
	    DynamicUser = "yes";
	};
	script = ''
	    ${lib.getExe pkgs.vulnix} --system --json | curl 
	'';
    };#timer for scans which curl their json into influxdb via monitoring task group
    systemd.timers.vulnix = {
	enable = true;
	wanteBy = [ "multi-user.target" ];
	timerConfig = {
	    Unit = "vulnix.service";
	    OnBootSec="15min";
	    OnUnitActiveSec="1w";
	};
    };
}
