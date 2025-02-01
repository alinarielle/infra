{config, nodes, lib, pkgs, name, opt, cfg, ...}: let
  peers = lib.filterAttrs (key: val: 
    val.config.l.network.wgmesh.enable
  ) nodes;
in {
  opt = with lib.types; {
    rosenpass = lib.mkOption {
      type = bool;
      default = true;
    };
    port = lib.mkOption {
      type = port;
      default = config.l.network.getPort "wg-mesh";
    };
    interface = lib.mkOption {
      type = str;
      default = "wg-mesh";
    };
    ipv4 = lib.mkOption {
      type = str;
      default = config.l.network.ipgen.v4.private;
    };
    ipv6 = lib.mkOption {
      type = str;
      default = config.l.network.ipgen.v6.private;
    };
    keepAlive = lib.mkOption {
      type = bool;
      default = true;
    };
  };
  services.bird2 = {
    enable = true;
    config = ''
      log syslog all;
      protocol device {}
      router id ${builtins.toString config.l.network.hostInfo.wanIPv4};
      protocol direct {
	interface
      }
    '';
  };
}
# handle VMs in addition to nodes
