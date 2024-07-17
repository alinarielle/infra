{lib, config, name, ...}:
with lib; with builtins; {
    options.l.services.firefox-sync.enable = mkEnableOption "firefox sync";
    config = mkIf config.l.services.firefox-sync.enable {
	l.meta.services.firefox-sync.priority = "moderate";
	firefox-syncserver = {
	    enable = true;
	    singleNode = {
		enableNginx = true;
		enableTLS = true;
		hostname = "ffsync.alina.cx";
	    };
	    settings = {
		port = lib.net.getPort "firefox-sync";
	    };
	};
    };
}
