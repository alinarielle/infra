{lib, config, ...}:
{
    options.l.services.paperless = {
	enable = lib.mkEnableOption "paperless";
    };
    config = let
	cfg = config.l.services.paperless;
	in
	lib.mkIf cfg.enable {
	    services.paperless = {
		enable = true;
		dataDir = "/srv/paperless";
		passwordFile = "/secrets/services/paperless/adminPassword";
		settings = {
		    PAPERLESS_CONSUMER_IGNORE_PATTERN = [
			".DS_STORE/*"
			"desktop.ini"
		    ];
		    PAPERLESS_DBHOST = "/run/postgresql";
		    PAPERLESS_OCR_LANGUAGE = "deu+eng";
		    PAPERLESS_OCR_USER_ARGS = {
			optimize = 1;
			pdfa_image_compression = "lossless";
		    };
		};
		port = lib.net.getPort "paperless";
		address = "localhost";
	    };
	    services.syncthing = {
		
	    };
	    l.meta.services.wrap = [{
		name = "paperless";
		priority = "critical";
	    }];
	};
}
