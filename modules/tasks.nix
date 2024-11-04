{lib, config, opt, cfg, ...}: {
  opt = with lib.types; lib.mkOption { default = {}; type = attrsOf (submodule {
    options = {
      enable = lib.mkEnableOption "task"; #TODO fix mkLocalMods submodule enableOpts
      script = lib.mkOption { type = nullOr lines; default = null; };
      bins = lib.mkOption { type = listOf path; default = []; };
      net = lib.mkEnableOption "networking permission CAP_NET for systemd service";
      netAdmin = lib.mkEnableOption "networking permission CAP_NET_ADMIN for systemd service";
      execInterval = lib.mkOption { type = nullOr str; default = null; };
      execDate = lib.mkOption { type = nullOr str; default = null; };
      user = lib.mkOption { type = nullOr str; default = null; };
      group = lib.mkOption { type = nullOr str; default = null; };
      dataDir = lib.mkOption { type = nullOr path; default = null; };
      volatile = lib.mkEnableOption "wipe everything once the process is closed";
      #readWritePaths = lib.mkOption { type = listOf path; default = []; };
      #readOnlyPaths = lib.mkOption { type = listOf path; default = []; };
    };
  });};
  config = lib.mkMerge [
  ] ++ (lib.mapAttrsToList (key: val: let
    fld = config.l.folders;
    user = val.user or key;
    group = val.group or key;
    net = if val.netAdmin then true else val.net;
  in {
    l.folders = let 
      mkDir = type: { ${key}-${type} = {
        path = if val.dataDir != null then "${val.dataDir}${type}" else "/jail/${key}${type}";
        inherit user group;
      };};
    in lib.mkIf !val.volatile ((mkDir "/lib") // (mkDir "/log") // (mkDir "/cache"));
    
    users.users.${user} = {
      inherit group;
      isSystemUser = true;
    };

    systemd.services.${key} = (lib.recursiveUpdate {
      unitConfig = lib.mkIf config.l.filesystem.impermanence.enable {
        RequiresMountsFor = "/persist";
      };
      wants = lib.optionals net ["networking.target"];
      wantedBy = ["multi-user.target" "timers.target"];

      startLimitBurst = 1;

      script = if 
        (((lib.length val.bins) == 1) && (val.script == null)) 
      then ''
        #!/bin/bash
	${lib.head val.bins}
      ''
      else val.script;

      serviceConfig = rec {
        # filesystem setup
	RootDirectory = val.dataDir or "/jail/${key}";
	MountAPIVFS = true;
	PrivateTmp = true;
	PrivateDevices = true;
	PrivateMounts = true;
	ProcSubset = "pid";
	ProtectProc = "noaccess";
	BindReadOnlyPaths = [
	  "/dev/log"
	  "/run/systemd/journal/socket"
	  "/run/systemd/journal/stdout" # necessary for logging
	  "/nix/store"
	];
	BindPaths = [
	  #"${fld.${key}-cache.path}:${CacheDirectory}"
	  #"${fld.${key}-log.path}:${LogsDirectory}"
	  "/var/lib/${key}:/lib"
	  "/var/log/${key}:/log"
	  "/var/cache/${key}:/cache"
	];
	WorkingDirectory = "/lib";

	StateDirectory = "${key}:/lib";
	StateDirectoryMode = "0750";

        CacheDirectory = "${key}:/cache";
	CacheDirectoryMode = "0750";
        
	LogsDirectory = "${key}:/log";
        LogsDirectoryMode = "0750";
	
	NoExecPaths = "/";
	ExecPaths = val.bins ++ ["/nix/store"];
	
	#TemporaryFileSystem = ["/:ro"];

	# new file permissions
	UMask = "0027"; # 0640 / 0750

	#TemporaryFileSystem = ":ro";

	User = user;
	Group = group;
	
	Restart = "on-failure";
	PrivateUsers = true;
	ProtectSystem = "strict";
	ProtectHome = true;
	ProtectHostname = true;
        ProtectClock = true;
	ProtectKernelTuneables = true;
	ProtectKernelModules = true;
	ProtectKernelLogs = true;
	ProtectControlGroups = true;
	RestrictAddressFamilies = [ 
	  (lib.mkIf !val.volatile "AF_UNIX")
	  (lib.mkIf net "AF_INET") 
	  (lib.mkIf net "AF_INET6")
	];
	RestrictNamespaces = true;
	LockPersonality = true; # lock linux process execution domain as in personality(2)

	MemoryDenyWriteExecute = true; 
	  # prevents processes from changing running code dynamically, BUT:
	  # note that this option is incompatible with programs and libraries that generate 
	  # program code dynamically at runtime, including JIT execution engines, executable- 
	  # stacks, and code "trampoline" feature of various C compilers.
	  # However, the protection can be circumvented, if the service can write to a 
	  # filesystem, which is not mounted with noexec (such as /dev/shm), or it can use 
	  # memfd_create(). This can be prevented by making such file systems inaccessible to
	  # the service by setting
	InaccessiblePaths= "/dev/shm";
	  # and installing further system call filters such as:
	SystemCallFilter = [ 
	  ("~@cpu-emulation @memfd_create @debug @keyring @mount"
	  + " @obsolete @privileged @setuid" 
	];

	RestrictRealtime = true;
	RestrictSUIDSGID = true;
	RemoveIPC = true;
	PrivateMounts = true;
	DevicePolicy = "closed";
	PrivateNetwork = !net;
	KeyringMode = "private";
	
	# capabilities(7)
	NoNewPrivileges = true;
	AmbientCapabilities = [
	  (lib.mkIf val.netAdmin "CAP_NET_ADMIN")
	  (lib.mkIf net "CAP_NET")
	  (lib.mkIf net "CAP_NET_BIND_SERVICE")
        ];
      };
    }(lib.mkIf val.volatile {
      serviceConfig = {
        DynamicUser = true;
	RuntimeDirectory = "woof:/woof";
	User = null;
	Group = null;
	BindPaths = [];
	WorkingDirectory = null;
        RuntimeDirectoryMode = null;
        CacheDirectory = null;
	CacheDirectoryMode = null;
	LogsDirectory = null;
        LogsDirectoryMode = null;
      };
    }));

    systemd.timers.${key} = {
      startLimitBurst = 1;
      timerConfig = {
	Unit = key + ".service";
	OnUnitActiveSec = val.execInterval;
	OnCalendar = val.execDate;
      };
    };

    security.apparmor = lib.mkIf l.kernel.apparmor.enable {
      enable = true;
      killUnconfinedConfinables = true;
      enableCache = true;
    };
  }) cfg);
}
# TODO
# kill service
# look into nspawnd
# look into the implicatons of dynamic users and other systemd.exec options
# read this https://www.ctrl.blog/entry/systemd-opensmtpd-hardening.html

