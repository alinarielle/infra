{lib, config, name, ...}: 
with lib; with builtins; with import ../lib {inherit lib config;};
let
    cfg = config.backup;
    opt = mkOption;
in
{
    options.backup = with types; {
	paths = opt { type = listOf str; default = []; };
	exclude = opt { type = listOf str; default = []; };
	cmd = opt { type = str; default = null; };
    };

    config = lib.mkIf cfg.dirs != [] {
	services.restic = {
	    backups = {
		backup = {
		    paths = cfg.dirs;
		    exclude = cfg.exclude;
		    repository = "s3:https://restic.alina.cx/${name}";
		    initialize = true;
		    RandomizedDelaySec = "2h";
		    passwordFile = "/secrets/${name}/backup/restic.private";
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
		    dynamicFilesFrom = cfg.cmd;
		};
	    };
	};
    };
}
