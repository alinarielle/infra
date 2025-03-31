{opt, pkgs, cfg, lib, config, nodes, name, ...}: let
  peersConfig = lib.filterAttrs (key: val: 
    val.config.l.network.wireguard.enable
  ) nodes;
  makeTunnel = { 
    peers ? cfg.tunnel.peers
  }@args: {
    
  };
in {
  assertions = [(lib.mkIf !cfg.tunnel.proxyOthers {
    assertion = !(any (x: name == x.l.wireguard.tunnel.proxyTo) (attrValues peersConfig));
    message = "(an)other host(s) selected you as proxy, but you denied being a proxy!"
  })];
  imports = [ sops.nixosModules.sops ];
  opt = with lib.types; {
    tunnel = {
      make = lib.mkOption { type = functionTo attrs; default = makeTunnel; };
      peers = lib.mkOption { 
        type = nullOr 
	  (listOf 
	    (attrsOf 
	      (either 
		(enum 
		  (attrNames nodes)
		) 
		path
	      )
	    )
	  );
	default = null;
	example = [{
	  peer = "eris";
	  relPeerPublicKey = "/wireguard/eris/wg.public";
	}];
      };
      rosenpass = lib.mkOption { type = bool; default = true; };
      keepAlive = lib.mkOption { type = nullOr int; default = 25; };
      proxyTo = lib.mkOption { 
        type = nullOr enum (attrNames nodes); 
	default = null;
	description = ''change to the hostname to use that node as proxy, 
			or leave as null to disable'';
      };
      proxyOthers = lib.mkEnableOption "whether to forward the entire traffic of peers";
      sops.keyPath = lib.mkOption { type = path; default = ./../../secrets; };
      sops.relSelfPrivateKey = lib.mkOption { 
        type = path; 
	default = "/wireguard/${name}/wg.private"; 
      };
      sops.relSelfPublicKey = lib.mkOption { 
        type = path; 
	default = "/wireguard/${name}/wg.public"; 
      };
      port = lib.mkOption { type = port; default = config.l.network.getPort "wireguard"; };
      #interface = {
        #name = lib.mkOption { type = str; };
        #restrictToInterface = lib.mkOption { type = bool; default = true; };
        #generateInterface = lib.mkOption { type = bool; default = true; };
      #};
      ip = {
	v6 = {
	  enable = lib.mkOption { type = bool; default = true; };
	  private = lib.mkOption { 
	    type = str; 
	    default = with (import ../../lib/ip-util.nix {}).ipv6; let
	      alphabet = (lib.filter 
	        (x: x != "" ) 
		(lib.splitString "" "abcdefghijklmnopqrstuvwxy")
	      );
	      dividend = lib.toIntBase10 (builtins.substring 0 19 (
		alphabet
		(lib.imap (int: v: builtins.toString int) alphabet)
		(builtins.hashString "sha256" "wg-${name}")
	      ));
	    in encode (
	      (decode "fc00::/7") #7-bit special ULA range prefix
	      + (decode "0000:1312:b00b::/40") #40-bit Globally Unique ID
	      + (lib.mod 
		  dividend #pseudo-random entropy source
		  (decode "0:0:0:0:ffff::/32") #16-bit Interface ID range
	      )
	      + (decode "::1/128") #48-bit address
	    ); 
	  };
	  fqdn = lib.mkOption {
	    type = nullOr str;
	    default = config.networking.fqdn;
	  };
	};
      };
    };
  };
  config = {
    l.network.wireguard.tunnel.peers = [{
      peer = "eris";
      relPeerPublicKey = "/wireguard/eris/wg.public";
    }];
    systemd.network = cfg.tunnel.make {};
    services.rosenpass = lib.mkIf cfg.rosenpass.enable {
      enable = true;
      settings = {};
    };
    networking.wireguard = {};
    networking.wg-quick = {};
  };
}
#provide an interface for creating wg tunelns, meshs, routed meshs, 
#support port forwarding
#expose modules that activate specific mesh configurations and conflict with others
#from these do systemd-run and terraform
#create collection of environmental facts, like hidpi or disk or ip addresses
#create network interface for every tunnel and create mesh interfaces as bridges
#also handle VMs
#generate IPv6 private addresses ULA
#get public primary address from environment facts
#sops secret management
