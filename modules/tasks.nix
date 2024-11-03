{lib, config, opt, cfg, ...}: {
  opt.index = with lib.types; lib.mkOption { default = {}; type = listOf (submodule {
    options = {
      script = lib.mkOption { type = lines; };
      net = lib.mkEnableOption "networking permission CAP_NET for systemd service";
      netAdmin = lib.mkEnableOption "networking permission CAP_NET_ADMIN for systemd service";
      override = {
	service = lib.mkOption { type = attrs; };
	timer = lib.mkOption { type = attrs; };
      };
      merge = {
	service = lib.mkOption { type = attrs; };
	timer = lib.mkOption { type = attrs; };
      };
      execInterval = lib.mkOption { type = str; };
      execDate = lib.mkOption { type = str; };
    };
  });};
  config = lib.mkMerge [
  
  ] ++ (lib.mapAttrsToList (key: val: {
    systemd.services.${key} = (lib.recursiveUpdate {
      unitConfig = lib.mkIf config.l.filesystem.impermanence.enable {
        RequiresMountsFor = "/persist";
      };
      wants = [
	(lib.mkIf (cfg.netAdmin || cfg.net ) "networking.target")
      ];
      wantedBy = [ "multi-user.target" "timers.target" ];
      startLimitBurst = 1;
      serviceConfig = {
	DynamicUser = "yes";
	NoNewPrivileges = "yes";
	ProtectKernelLogs = "yes";
	ProtectKernelModules = "yes";
	ProtectKernelTuneables = "yes";
	ProtectControlGroups = "yes";
	ProtectSystem = "full";
	ProtectHome = "yes";
	ProtectDevices = "yes";
	RestrictSUIDSGID = "yes";
	MemoryDenyWriteExecute = "yes";
	InaccessiblePaths= "/dev/shm";
	SystemCallFilter= "~memfd_create";
	DevicePolicy = "closed";
	PrivateMounts = "yes";
	PrivateNetwork = lib.mkIf !(cfg.net || cfg.netAdmin)  "yes";
	AmbientCapabilities = [
	    (lib.mkIf cfg.networkingAdmin "CAP_NET_ADMIN")
	];
      };
      script = cfg.script;
    } cfg.merge.service) // cfg.override.service;

    systemd.timers.${key} = (lib.recursiveUpdate {
      startLimitBurst = 1;
      timerConfig = {
	Unit = "${key}.service";
	OnUnitActiveSec = cfg.execInterval;
	OnCalendar = cfg.execDate;
      };
    } cfg.merge.timer) // cfg.override.timer;
  }) cfg.index)
}
# TODO
# directory/file allow list which are mounted into tmpfs
# take stuff from service confinement:
# - hardening options
# look into nspawnd
# look into the implicatons of dynamic users and other systemd.exec options
# read this https://www.ctrl.blog/entry/systemd-opensmtpd-hardening.html

