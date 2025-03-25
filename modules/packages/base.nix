{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
	tlp
	acpid
	lm_sensors
    ];
}
