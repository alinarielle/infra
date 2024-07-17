{
    environment.systemPackages = with pkgs; [
	tlp
	acpid
	kitty.terminfo
    ];
    imports = [
	./games
    ];
}
