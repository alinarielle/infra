{opt, cfg, lib, name, ...}: {
  opt = with lib.types; {
    paths = lib.mkOption { type = listOf path; default = []; };
    exclude = lib.mkOption { type = listOf path; default = []; };
  };
  #l.services.garage.enable = true;
  services.restic = {
    backups = {
      backup = {
	paths = cfg.paths;
	exclude = cfg.exclude;
	#repository = "s3:https://restic.alina.cx/${name}";
	initialize = true;
	RandomizedDelaySec = "2h";
	#passwordFile = "/secrets/${name}/backup/restic.private";
	timerConfig = {
	    OnCalendar = "04:30";
	};
	pruneOpts = [
	    "--keep-daily 7"
	    "--keep-weekly 5"
	    "--keep-monthly 12"
	    "--keep-yearly 75"
	];
	rcloneConfigFile = "/secrets/${name}/backup/s3.private";
      };
    };
  };
}
