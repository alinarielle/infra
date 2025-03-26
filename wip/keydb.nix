{opt, cfg, lib, pkgs, utils, srv, ...}: with lib.types; {
  opt = {
    package = lib.mkPackageOption pkgs "KeyDB" {
      default = pkgs.keydb;
    };
    extraArgs = lib.mkOption {
      type = listOf str;
      default = [];
    };
    listen = lib.mkOption {
      type = listOf str;
      default = ["127.0.0.1" "::1"];
      description = ''Specify the addresses to bind to and listen for incoming connections.
		      Force the list to be empty with `lib.mkForce []` to listen on ALL inter-
		      faces.
      '';
    };
    port = lib.mkOption {
      type = port;
      default = 6379; #IANA 815344
      description = ''
	Specify the port you want to listen on. If 0 is specified, KeyDB will not listen on a
	TCP Socket.
      '';
    };
    protectedMode = lib.mkOption {
      type = bool;
      default = true;
      description = ''
	Protected Mode prevents other hosts from connecting if 1) the server is not
	explicitly listening on any addresses and 2) no password is configured.
      '';
    };
    tcpBacklog = lib.mkOption {
      type = int;
      default = 511;
      descripton = ''In high requests-per-second environments you need a high backlog in 
		     order to avoid slow clients connections issues. Note that the Linux 
		     kernel will silently truncate it to the value of 
		     /proc/sys/net/core/somaxconn so make sure to raise both the value of 
		     somaxconn and tcp_max_syn_backlog in order to get the desired effect.
      '';
    };
    unixSocket = lib.mkOption {
      type = nullOr str;
      default = null;
      description = ''
	Specify the path for the Unix socket that will be used to listen for incoming 
	connections. There is no default, so KeyDB will not listen on a unix socket when not 
	specified.
      '';
    };
    unixSocketPerm = lib.mkOption {
      type = int;
      default = 700;
      description = ''
	The file permissions of the unix socket used for incoming connections.
      '';
    };
    timeout = lib.mkOption {
      type = int;
      default = 20;
      description = ''
	Close the connection after a client is idle for N seconds (0 to disable).
      '';
    };
    tcpKeepalive = lib.mkOption {
      type = int;
      default = 300;
      description = ''
	If non-zero, use SO_KEEPALIVE to send TCP ACKs to clients in absence of communication.
	This is useful for two reasons:
	 1) Detect dead peers.
	 2) Take the connection alive from the point of view of 
	    network equipment in the middle.

	On Linux, the specified value (in seconds) is the period used to send ACKs.
	Note that to close the connection the double of the time is needed.
	On other kernels the period depends on the kernel configuration.
      '';
    };
    logVerbosity = lib.mkOption {
      type = enum [
	"debug" "verbose" "notice" "warning"
      ];
      default = "notice";
      description = ''
	The verbosity of the server's log output.
      '';
    };
    databases = lib.mkOption {
      type = int;
      default = 16;
      description = ''
	Set the number of databases. The default database is DB 0, you can select a different 
	one on a per-connection basis using SELECT <dbid> where dbid is a number between 
	0 and 'databases'-1.
      '';
    };
    saveAfter.seconds = lib.mkOption {
      type = int;
      default = 300;
      description = ''
	Specify the interval between saving the database in seconds. Set to 0 to disable
	saving altogether.
      '';
    };
    saveAfter.keys = lib.mkOption {
      type = int;
      default = 0;
      description = ''
	Specify how many keys need to have changed in order for the database to save to disk.
      '';
    };
    extraConfig = lib.mkOption {
      type = nullOr lines;
      default = null;
      description = ''
	Extra config to append to the config file.
      '';
    };
    replication = {
      enable = lib.mkEnableOption "replication";
      main = {
	fqdn = lib.mkOption {
	  type = nullOr str;
	  default = null;
	};
	port = lib.mkOption {
	  type = nullOr port;
	  default = null;
	};
	password = lib.mkOption {
	  type = nullOr str;
	  default = null;
	};
	user = lib.mkOption {
	  type = nullOr str;
	  default = null;
	};
      };
    };
  };
  config = {
    srv.script = utils.escapeSystemdExecArgs [(lib.getExe cfg.package)] 
    ++ cfg.extraArgs 
    ++ [(
      pkgs.writeText "keydb.conf" ''
	${lib.mkIf 
	  (cfg.listen != []) 
	  ("bind" + builtins.concatStringsSep " " cfg.listen)
	}
	${if cfg.protectedMode then "protected-mode yes" else "protected-mode no"}
	${"port " + builtins.toString cfg.port}
	${"tcp-backlog " + cfg.tcpBacklog}
	${lib.mkIf (cfg.unixSocket != null) "unixsocket " + cfg.unixSocket}
	unixsocketperm ${cfg.unixSocketPerm}
	timeout ${cfg.timeout}
	tcp-keepalive ${cfg.tcpKeepalive}
	daemonize no
	supervised systemd
	loglevel ${cfg.logVerbosity}
	logfile ""
	databases ${cfg.databases}
	always-show-logo yes
	save ${if cfg.saveAfter.seconds == 0 then "" 
	else 
	  (builtins.toString cfg.saveAfter.seconds) 
	  + " " 
	  + (builtins.toString cfg.saveAfter.keys)
	}
	stop-writes-on-bgsave-error yes
	rdbcompression yes
	rdbchecksum yes
	dbfilename keydb_dump.rdb
	dir ./
      ''
      + (if cfg.replication.enable then with cfg.replication.main; ''
	replicaof ${fqdn} ${port}
	masterauth ${password}
	masteruser ${user}
	replica-serve-stale-data yes
	replica-read-only yes
	repl-diskless-sync no
	repl-diskless-sync-delay 0
	repl-ping-replica-period 10
	repl-timeout 60
	repl-disable-tcp-nodelay no
	repl-backlog-size 1mb
	repl-backlog-ttl 3600
	replica-priority 100
      '' else '''')
      + cfg.extraConfig
    )];
  };
}
