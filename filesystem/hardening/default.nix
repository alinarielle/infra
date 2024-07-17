{lib, config, ...}: {
    imports = [
	./blacklist.nix
	./noexecMount.nix
	./sysctl.nix
    ];
    options.l.filesystem.hardening.enable = lib.mkEnableOption "filesystem hardening";
    config = lib.mkIf config.l.filesystem.hardening.enable {
	l.filesystem.hardening = {
	    blacklist.enable = true;
	    noexecMount.enable = true;
	    sysctl.enable = true;
	};
    };
}
