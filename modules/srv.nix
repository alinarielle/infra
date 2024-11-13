{opt, cfg, lib, config, ...}: {
  opt = with lib.types; lib.mkOption { default = {}; type = (submodule {
    options = {
      script = lib.mkOption { type = nullOr lines; default = null; };
      persist = lib.mkOption { type = bool; default = true; };
      dataDir = lib.mkOption { type = nullOr path; default = null; };
      net = {	
	serve = {
	  intranet = lib.mkOption { type = bool; default = false; };
	  clearnet = lib.mkOption { type = bool; default = false; };
	  onion = lib.mkOption { type = bool; default = false; };
	  garlic = lib.mkOption { type = bool; default = false; };
	  dn42 = lib.mkOption { type = bool; default = false; };
        };
	dns = {
	  enable = lib.mkEnableOption "DNS with sane defaults";
	  sub = lib.mkOption { type = nullOr str; default = null; };
	  domain = lib.mkOption { type = nullOr str; default = null; };
	  fqdn = lib.mkOption { type = nullOr str; default = null; };
	};
	ports = lib.mkOption { type = listOf port; default = [ 443 ]; };
      };
      paths = {
	ro = lib.mkOption { type = listOf path; default = []; };
	rw = lib.mkOption { type = listOf path; default = []; };
	exec = lib.mkOption { type = listOf path; default = []; };
      }; 
    };
  });};
  config = {
  # submodule option defaults
    #dns = {
      #sub = val.net.dns.sub or key;
      #domain = val.net.dns.domain or "alina.cx";
      #fqdn = val.net.dns.fqdn or dns.sub + "." dns.domain;
    #};


    l.tasks = lib.mapAttrs (key: val: {
      user = lib.mkIf val.persist key;
      group = lib.mkIf val.persist key;
      net = lib.mkIf (lib.any (x: x) lib.attrValues val.serve) true;
      inherit (val) paths persist dataDir script;
    }) cfg;
    

    assertions = lib.mapAttrsToList (key: val: {
      assertion = val.task != null;
      message = "the task of service ${key} cannot be undefined";
    }
    {
      assertion = val.paths.exec != [];
      message = "define at least one executable path for service ${key}";
    }
    (lib.mkIf config.l.filesystem.noexecMount.enable {
      assertion = (builtins.all (x: 
        (builtins.substring 0 11 x) == "/nix/store/") 
	val.paths.exec
      );
      message = ''all partitions except the nix store are mounted as noexec, executable paths
	must start with /nix/store'';
    })) cfg;
  };
}
