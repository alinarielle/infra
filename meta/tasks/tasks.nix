{lib, config, ...}: {
    options.l.task.tasks = with lib.types; lib.mkOption { 
	default = {};
	type = attrsOf (submodule {
	    options = {
		execInterval = lib.mkOption {
		    type = str;
		};
		execDate = lib.mkOption {
		    type = str;
		};
		script = lib.mkOption {
		    type = lines;
		};
		merge = lib.mkOption {
		    type = attrs;
		    default = {};
		};
		override = lib.mkOption {
		    type = attrs;
		    default = {};
		};
		networking = lib.mkEnableOption "networking perms";
		networkingAdmin = lib.mkEnableOption "administrative networking perms";
		allowedDirectories = lib.mkOption {
		    type = listOf str;
		    default = [];
		};
		permissions = lib.mkOption {
		    type = listOf str;
		    default = [];
		    description = "";
		};
	    };
    })};
    config = let
	cfg = config.l.task;
    in
    mkMerge (lib.mapAttrsToList (key: val: {
	systemd.services.${key} = lib.mkDefault (lib.recursiveUpdate {
	    unitConfig = lib.mkIf config.l.impermanence.enable {
		RequiresMountsFor = "/persist";
	    };
	    wants = [
		(lib.mkIf (cfg.networking || cfg.networking.target ) "networking.target")
	    ];
	    wantedBy = [ "multi-user.target" "timers.target" ];
	    startLimitBurst = 1;
	    serviceConfig = {
		DynamicUser = "yes";
		NoNewPrivileges = "yes";
		ProtectKernelLogs = "yes";
		ProtectKernelModules = "yes";
		ProtectKernelTuneables = "yes";
		ProtectSystem = "yes";
		ProtectHome = "yes";
		ProtectDevices= "yes";
		MemoryDenyWriteExecute = "yes";
		InaccessiblePaths= "/dev/shm";
		SystemCallFilter= "~memfd_create";
		DevicePolicy = "closed";
		PrivateMounts = "yes";
		PrivateNetwork = lib.mkIf !cfg.networking "yes";
		AmbientCapabilities = [
		    (lib.mkIf cfg.networkingAdmin "CAP_NET_ADMIN")
		];
	    };
	    script = cfg.script;
	} cfg.merge) // cfg.override;
	systemd.timers.${key} = lib.mkDefault {
	    startLimitBurst = 1;
	    timerConfig = {
		Unit = "${key}.service";
		OnUnitActiveSec = cfg.execInterval;
		OnCalendar = cfg.execDate;
	    };
	};
    }) cfg.tasks)
}
# directory/file allow list which are mounted into tmpfs
# take stuff from service confinement:
# - bringing packages into scope
# - hardening options

