{
    environment.systemPackages = with pkgs; [
	tlp
	acpid
	kitty.terminfo
    ];
    imports = [
	./games
	./archivetools.nix
	./fstools.nix
	./chat.nix
	./hardening
    ];
}
