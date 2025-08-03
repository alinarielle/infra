{config, inputs, pkgs, lib, utils, ...}: let
  cfg = config.tasks;
  inherit (lib)
    mkOption
    mkEnableOption
    mapAttrs
    mapAttrs'
    nameValuePair
    xor
    mkIf
    isDerivation
    head
    optionals
    getExe
    optionalString
    types
    hasPrefix;
  inherit (utils)
    escapeSystemdExecArgs;
in {
  options.tasks = with types; mkOption {
    default = {};
    type = attrsOf (submodule {
      options = {
        enable = mkOption { default = true; type = bool; };
        description = mkOption { default = null; type = nullOr lines; };
        persist = mkOption { default = true; type = bool; };
        script = mkOption { default = null; type = nullOr lines; };
        exec = mkOption { default = null; type = listOf str; };
        environment = mkOption { default = {}; type = attrs; };
        wrapper = {
          xdgDesktopFile = mkOption { default = true; type = bool; };
          timer = {};
        };
        extraConfig = {
          serviceConfig = mkOption { default = {}; type = attrs; };
          timerConfig = mkOption { default = {}; type = attrs; };
          unitConfig = mkOption { default = {}; type = attrs; };
        };
        network = {
          enable = mkEnableOption "CAP_NET";
          admin = mkEnableOption "CAP_NET_ADMIN";
          http = {};
          i2p = {};
          tor = {};
          mullvad = {};
          proxychains = {};
        };
        devices = {
          enable = mkEnableOption "access to non-private devices";
          blockDevices = mkEnableOption "access to raw block devices";
        };
        unix = {
          user = mkOption { default = null; type = nullOr str; };
          group = mkOption { default = null; type = nullOr str; };
          rw = mkOption { default = []; type = listOf path; };
          ro = mkOption { default = []; type = listOf path; };
          exec = mkOption { default = []; type = listOf path; };
        };
      };
    });
  };
  config = {
    users.users = mapAttrs' (key: val: with val.unix;
      nameValuePair
        (user or key)
        {
          group = group or key;
          isSystemUser = true;
        }
    ) cfg;
    users.groups = mapAttrs (key: val: with val.unix; {
      name = group or key;
    }) cfg;

    systemd.tmpfiles.settings.jails = { 
      "/jail".d = {
        user = "root";
        group = "root";
        mode = "750";
        age = "-";
      };
    } // mapAttrs (key: val: with val.unix; { d = {
      user = user or key;
      group = group or key;
      mode = "770";
      age = "-";
    }; }) cfg;

    home-manager.users.alina.xdg = {
      enable = true;
      desktopEntries = mapAttrs (key: val: let
        script = pkgs.writeShellApplication {
          name = key;
          runtimeInputs = [pkgs.systemdMinimal];
          text = ''
            systemd-run ${key}
          '';
        };
      in mkIf val.wrapper.xdgDesktopFile {
        comment = "launcher for systemd-service ${key}";
        name = key;
        exec = "${lib.getExe script}";
        terminal = true;
      }) cfg;
    };
    
    systemd.services = mapAttrs (key: val: with val.unix; {
      inherit (val) script description;
      inherit (val.extraConfig) unitConfig;
      wants = optionals val.network.enable ["networking.target"];
      wantedBy = ["multi-user.target"];
      environment = {
        #STATE_DIRECTORY = "/lib";
      } // val.environment;
      serviceConfig = {
        ExecStart = optionalString 
          (val.exec != null) 
          (escapeSystemdExecArgs 
            (map 
              (x: if isDerivation x then getExe x else x) 
              val.exec
            )
          );
        Restart = "on-failure";
        RestartSec = "10s";
        StartLimitBurst = 1;

        RootDirectory = "/jail/${key}";
        TemporaryFileSystem = ["/:ro"];
        MountAPIVFS = true;
        PrivateTmp = true;
        PrivateDevices = !val.devices.enable;
        PrivateMounts = true;
        ProcSubset = "pid";
        ProtectProc = "noaccess";
        BindPaths = [
          "/dev/log"
          "/run/systemd/journal/stdout"
          "/run/systemd/journal/socket"
          "/var/lib/${key}:/lib"
          "/var/log/${key}:/log"
          "/var/cache/${key}:/cache"
        ] ++ val.unix.rw;
        BindReadOnlyPaths = [
          "/nix/store"
        ] ++ val.unix.ro;
        NoExecPaths = "/";
        ExecPaths = val.unix.exec ++ optionals 
          (isDerivation (head val.exec))
          (head val.exec);
        WorkingDirectory = "/lib";
        StateDirectory = "/lib";
        StateDirectoryMode = "0750";
        CacheDirectory = "/cache";
        CacheDirectoryMode = "0750";
        LogsDirectory = "/log";
        LogsDirectoryMode = "0750";
        UMask = "0027";
        User = user or key;
        Group = group or key;
        PrivateUsers = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        SystemCallArchitectures = "native";
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictAddressFamilies = [ "AF_UNIX" ] ++ optionals (val.network.enable) [
          "AF_INET" 
          "AF_INET6"
        ];
        MemoryDenyWriteExecute = true;
        InaccessiblePaths = "/dev/shm";
        SystemCallFilter = 
          ["~@cpu-emulation @memfd_create @debug @keyring @mount @obsolete @privileged @setuid"];
        RestrictRealtime = true;
        RemoveIPC = true;
        DevicePolicy = "closed";
        PrivateNetwork = !val.network.enable;
        KeyringMode = "private";
        NoNewPrivileges = true;
        AmbientCapabilities = optionals (val.network.enable) [
          "CAP_NET"
          "CAP_NET_BIND_SERVICE"
        ] ++ optionals (val.network.admin) [
          "CAP_NET_ADMIN"
        ];
      } // val.extraConfig.serviceConfig;
    }) cfg;
  };
}
# TODO: figure out how to combine with multi-homed
# TODO: credentials
# TODO: http balancer that takes one nginx from every instance as upstream
# TODO: 464xlat
# TODO; wireguard mesh integration, allow interface to interface communication and establish vpn
# TODO: network options to route through TOR, I2P, clearnet etc, private network etc
# TODO: netfilter rules
# TODO: encrypted client hello and TLS termination
# TODO: resource control for IP allow ranges
# TODO: kanidm integration
# TODO: restrict to interfaces
# TODO: private network with nginx reverse proxy
# TODO: udev management
# TODO: generate scripts launching these services with systemd-run and wrap in XDG desktop entries
