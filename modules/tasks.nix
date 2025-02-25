{lib, config, opt, cfg, utils, ...}: {
  opt = with lib.types; lib.mkOption { default = {}; type = attrsOf (submodule {
    options = {
      enable = lib.mkEnableOption "task";
      script = lib.mkOption { type = nullOr lines; default = null; };
      exec = lib.mkOption { type = nullOr list; default = null; };
      env = lib.mkOption { type = attrs; default = {}; };
      paths = {
        exec = lib.mkOption { type = listOf path; default = []; };
        ro = lib.mkOption { type = listOf path; default = []; };
        rw = lib.mkOption { type = listOf path; default = []; };
      };
      net = lib.mkEnableOption "networking permission CAP_NET for systemd service";
      netAdmin = lib.mkEnableOption "networking permission CAP_NET_ADMIN for systemd service";
      execInterval = lib.mkOption { type = nullOr str; default = null; };
      execDate = lib.mkOption { type = nullOr str; default = null; };
      user = lib.mkOption { type = nullOr str; default = null; };
      group = lib.mkOption { type = nullOr str; default = null; };
      dataDir = lib.mkOption { type = nullOr path; default = null; };
      persist = lib.mkOption { type = bool; default = true; };
    };
  });};
  config = let
    mapVals = fn: attrs: lib.mkMerge (lib.attrValues (lib.mapAttrs fn attrs));
  in {
    l.folders = lib.mapAttrs (key: val: let 
      mkDir = type: { "${key}-${type}" = {
        path = if val.dataDir != null then "${val.dataDir}${type}" else "/jail/${key}${type}";
	user = val.user or key;
	group = val.group or key;
      };};
    in lib.mkIf val.persist ((mkDir "/lib") // (mkDir "/log") // (mkDir "/cache"))) cfg;
    
    users.users = mapVals (key: val: { ${val.user or key} = {
      group = val.group or key;
      isSystemUser = true;
    };}) cfg;

    systemd.services = lib.mapVals (key: val: let
      net = if val.netAdmin then true else val.net;
    in { "${key}-srv" = {
      unitConfig = lib.mkIf config.l.filesystem.impermanence.enable {
        RequiresMountsFor = "/persist";
      };
      wants = lib.optionals net ["networking.target"];
      wantedBy = ["multi-user.target" "timers.target"];
      description = key;
      startLimitBurst = 1;
      environment = val.env;

      script = if 
        ((lib.length val.paths.exec) == 1) && (val.script == null)
      then ''
        #!/bin/bash
	${lib.head val.paths.exec}
      ''
      else val.script;

      serviceConfig = {
	ExecStart = lib.mkIf (val.exec != null) (utils.escapeSystemdExecArgs val.exec);
        # filesystem setup
	RootDirectory = val.dataDir or "/jail/${key}";
	TemporaryFileSystem = ["/:ro"];
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
	] ++ val.paths.ro;
	BindPaths = [
	  "/var/lib/${key}:/lib"
	  "/var/log/${key}:/log"
	  "/var/cache/${key}:/cache"
	] ++ val.paths.rw ++ [val.dataDir];
	
	NoExecPaths = "/";
	ExecPaths = val.paths.exec;

	WorkingDirectory = val.dataDir or "/lib";

	StateDirectory = val.dataDir or "${key}:/lib";
	StateDirectoryMode = "0750";

        CacheDirectory = "${key}:/cache";
	CacheDirectoryMode = "0750";
        
	LogsDirectory = "${key}:/log";
        LogsDirectoryMode = "0750";

	# new file permissions
	UMask = "0027"; # 0640 / 0750
	User = val.user or key;
	Group = val.group or key;
	
	Restart = "on-failure";
	RestartSec = 10;
	StartLimitBurst = 1;

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
	  (lib.mkIf val.persist "AF_UNIX")
	  (lib.mkIf net "AF_INET") 
	  (lib.mkIf net "AF_INET6")
	];
	SystemCallArchitectures = "native";
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
	  + " @obsolete @privileged @setuid")
	];

	RestrictRealtime = true;
	RestrictSUIDSGID = true;
	RemoveIPC = true;
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
      } // (if val.persist then {} else {
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
      });
    };}) cfg;

    systemd.timers = lib.mapAttrs (key: val: {
      startLimitBurst = 1;
      timerConfig = {
	Unit = key + ".service";
	OnUnitActiveSec = val.execInterval;
	OnCalendar = val.execDate;
      };
    }) cfg;
  };
}
#TODO systemd credentials, resource control for IP allow ranges, restrict to interfaces,
#restrict to protocols
