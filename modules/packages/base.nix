{pkgs, ...}: {
    environment.systemPackages = with pkgs; [
	tlp
	acpid
    ];
}
