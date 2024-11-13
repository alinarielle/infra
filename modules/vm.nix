{lib, inputs, pkgs, cfg, opt, config, ...}: {
  opt = with lib.types; lib.mkOption { default = {}; type = (subodule {
    options = {
      config = lib.mkOption { type = attrs; default = {}; };
      priority = lib.mkOption { type = enum ["low" "moderate" "critical"]; };
      autostart = lib.mkOption { type = bool; default = true; };
    };
  });};
  imports = [ inputs.microvm.nixosModules.host ];
  config = let
    inherit (config.l.lib) enable;
  in {
    microvm.autostart = lib.mapAttrsToList (key: val: lib.mkIf val.autostart "vm-${key}") cfg;
    microvm.vms = lib.mapAttrs' (name: value: lib.nameValuePair ("vm-${name}") ({
      inherit pkgs;
      imports = [ value.config ];
      networking.hostName = lib.mkDefault "vm-${name}";
      l.packages = enable ["base" "filesystem" "networking" "cryptography"];
      l.users.alina = enable ["home-manager" "ssh" "nvim" "user" "zsh"];
      l.users.root = enable ["home-manager" "ssh" "zsh"];
      l.network = enable ["domain" "congestion" "speed" "time" "networkd"];
      l.profiles = enable ["hardened"];
      deployment.tags = ["vm"];
      microvm = {
        hypervisor = lib.mkDefault "cloud-hypervisor";
        shares = [{
	  source = "/nix/store";
	  mountPoint = "/nix/.ro-store";
	  tag = "ro-store";
	  prot = "virtiofs";
        }];
      };
    })) cfg;
    # bridge
    l.network.networkmanager.enable = lib.mkForce false;
    l.network.networkd.enable = true;
    systemd.network.networks = lib.mapAttrs' (name: value: lib.nameValuePair 
      ("uplink-vm-${name}") 
      ({
	macvlan = ["macvlan-vm-${name}"];
	gateway = "";
	address = "";
	networkConfig = {
	  IPForward = true;
	  Gateway = "";
	  Address = "";
        };
        linkConfig = {
	  ARP = false;
        };
      })
    ) cfg;
    systemd.network.netdevs = lib.mapAttrs' (name: value: lib.nameValuePair 
      ("macvlan-vm-${name}") 
      ({
        macvlanConfig = {
	  Mode = "bridge";
        };
      })
    ) cfg;
  };
}
#TODO bridge interface, VNC, live migration
