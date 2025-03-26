{pkgs, opt, cfg, lib, nodes, ...}: let 
  hosts = lib.mapAttrsToList (key: val: 
    lib.mkIf val.l.filesystem.ceph.enable builtins.toString key
  ) nodes;
in {
  opt = with lib.types; {
    fsid = lib.mkOption { type = nullOr str; default = null; };
    clusterName = lib.mkOption { type = nullOr str; default = null; };
    extraConfig = lib.mkOption { default = null; type = nullOr lines; };
    net = {
      mesh = lib.mkEnableOption "Virtual Private Mesh Network between nodes";
    };
    client = {
      enable = lib.mkEnableOption "Ceph client";
    };
    pools = lib.mkOption { default = {}; type = attrsOf (submodule { options = {
      copies = lib.mkOption { default = 3; type = int; };
      erasureCoding = lib.mkEnableOption "Erasure Coding";
      crush = {};
    }; }); };
    mgr = lib.mkOption { default = {}; type = attrsOf (submodule { options = {
      enable = lib.mkEnableOption "Ceph Manager";
      fqdn = lib.mkOption { type = nullOr str; default = null; };
    }; }); };
    mon = lib.mkOption { default = {}; type = attrsOf (submodule { options = {
      enable = lib.mkEnableOption "Ceph Monitor";
      fqdn = lib.mkOption { type = nullOr str; default = null; };
    }; }); };
    rgw = lib.mkOption { default = {}; type = attrsOf (submodule { options = {
      enable = lib.mkEnableOption "RADOS S3 Gateway";
      fqdn = lib.mkOption { type = nullOr str; default = null; };
      mimeTypesFile = lib.mkOption { 
	type = nullOr path; 
	default = "${pkgs.mailcap}/etc/mime.types"; 
      };
    }; }); };
    osd = lib.mkOption { default = {}; type = attrsOf (submodule { options = {
      enable = lib.mkEnableOption "Ceph Object Storage Daemon";
      fqdn = lib.mkOption { type = nullOr str; default = null; };
      disks = lib.mkOption { type = listOf str; default = []; };
      maxOpenFiles = lib.mkOption { type = int; default = 131072; };
    }; }); };
    mds = lib.mkOption { default = {}; type = attrsOf (submodule { options = {
      enable = lib.mkEnableOption "Ceph Metadata Server";
      fqdn = lib.mkOption { type = nullOr str; default = null; };
    }; }); };
  };
  config = lib.mkMerge [{
    assertions = [{
      assertion = cfg.fsid != null;
      message = "${cfg}.fsid must be set!";
    }];
    environment.systemPackages = [ pkgs.ceph ];
    l.tasks = 
    lib.recursiveUpdate 
      (lib.mapAttrs (key: val: {
	enable = true;
	exec = [];
	path.exec =;
	user = "ceph";
	group = "ceph";
	dataDir = "/var/lib/ceph/mgr";
      }) cfg.mgr) 
      (lib.recursiveUpdate
        (lib.mapAttrs (key: val: {
	  enable = true;
	  exec = [];
	  user = "ceph";
	  group = "ceph";
	  dataDir = "/var/lib/ceph/mon";
	}) cfg.mon)
	(lib.recursiveUpdate
	  (lib.mapAttrs (key: val: {
	    enable = true;
	    exec = [];
	    user = "ceph";
	    group = "ceph";
	    dataDir = "/var/lib/ceph/rgw";
	  }) cfg.rgw)
	  (lib.recursiveUpdate
	    (lib.mapAttrs (key: val: {
	      enable = true;
	      exec = [];
	      user = "ceph";
	      group = "ceph";
	      dataDir = "/var/lib/ceph/osd";
	    }) cfg.osd)
	    (lib.mapAttrs (key: val: {
	      enable = true;
	      exec = [];
	      user = "ceph";
	      group = "ceph";
	      dataDir = "/var/lib/ceph/mds";
	    }) cfg.mds)
	  )
	)
      )
  }
  (lib.mkIf cfg.client.enable {
    environment.systemPackages = [ pkgs.ceph-client ];
  })];
}
