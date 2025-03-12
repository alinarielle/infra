{pkgs, opt, cfg, lib, nodes, ...}: let 
  hosts = lib.mapAttrsToList (key: val: 
    lib.mkIf val.l.filesystem.ceph.enable builtins.toString key
  ) nodes;
in {
  environment.systemPackages = with pkgs; [
    ceph ceph-client
  ];
  assertions = let
    checkDaemons = num: daemon: ; # check that the minimum requirements are met:
				  # 1 OSD per copy but at least 3, 3 mon, 2 mgr, 
				  # 1 mds per host if using CephFS, same with RGW
  in [{
    assertion = cfg.fsid != null;
    message = "${cfg}.fsid must be set!";
  }{
    assertion = ;
    message = ;
    
  }];
  opt = with lib.types; {
    fsid = lib.mkOption { type = nullOr str; default = null; };
    clusterName = lib.mkOption { type = nullOr str; default = null; };
    extraConfig = lib.mkOption { default = null; type = nullOr lines; };
    net = {
      mesh = lib.mkEnableOption "Virtual Private Mesh Network between nodes";
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
      mimeTypesFile = lib.mkOption { type = nullOr path; default = "${pkgs.mailcap}/etc/mime.types"; };
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
}
