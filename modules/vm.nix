{lib, inputs, pkgs, cfg, opt, config, ...}: {
  opt = with lib.types; lib.mkOption { default = {}; type = (subodule {
    options = {
      enable = lib.mkEnableOption "virtual machine";
      config = lib.mkOption { type = attrs; default = {}; };
      priority = lib.mkOption { type = enum ["low" "moderate" "critical"]; };
      autostart = lib.mkOption { type = bool; default = true; };
    };
  });};
  imports = [ inputs.microvm.nixosModules.host ];
  config = lib.mkMerge (lib.mapAttrsToList (key: val: let
    vm-name = "vm-" + key;
    inherit (config.l.lib) enable;
  in {
    microvm.autostart = lib.optionals val.autostart [ vm-name ];
    microvm.vms.${vm-name} = {
      inherit pkgs;
      imports = [ val.config ];
      networking.hostName = lib.mkDefault vm-name;
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
    };
    # bridge
    l.network.networkmanager.enable = lib.mkForce false;
    l.network.networkd.enable = true;
    systemd.network.networks."uplink-${vm-name}" = {
      macvlan = ["macvlan-${vm-name}"];
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

    };
    systemd.network.netdevs."macvlan-${vm-name}" = {
      macvlanConfig = {
	Mode = "bridge";
      };
    };
  }) cfg);
}
#TODO bridge interface, VNC, live migration
