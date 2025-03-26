{lib, config, name, pkgs, nodes, ...}:
let
    cfg = config.l.vm;
    opt = lib.mkOption;
in {
    options.l.vm = with lib.types; opt {
	default = {};
	type = attrsOf (submodule {
	    options = {
		enable = lib.mkEnableOption "VM for service x";
		method = opt { 
		    type = enum [ "cloud-hypervisor" "qemu" ];
		    #TODO: enter further methods
		    default = "cloud-hypervisor";
		};
		autostart = opt { type = bool; default = true; };
		extraConfig = opt { type = attrs; default = {}; };
		priority = opt { 
		    type = enum [ "critical" "moderate" "low"]; 
		    default = "moderate"; 
		};
		failoverMigration = {
		    enable = mkEnableOpton "VM migration in case of host failure";
		    failoverHost = opt { 
			type = enum (attrNames nodes);
			default = "snow";
		    };
		};
	    };
	});
    };
    config = lib.mkMerge [{
	}
	(lib.mkIf (cfg != {}) lib.attrValues (lib.mapAttrs (vm-name: val: {
	    microvm.vms.${vm-name} = {
		inherit pkgs;
		config = {
		    imports = [ val.extraConfig ];
		    networking.hostName = "vm-" + vm-name;
		    networking.domain = "infra.alina.cx";
		    microvm = {
			hypervisor = val.method;
			shares = [{
			    source = "/nix/store";
			    mountPoint = "/nix/.ro-store";
			    tag = "ro-store";
			    proto = "virtiofs";
			}]; #TODO: ceph compatability
		    };
		};
	    };
	    microvm.autostart = [ (lib.mkIf val.autostart ${vm-name}) ];
	    networking.useNetworkd = true;
	    systemd.network.networks.${"vm-" + vm-name + "-net"} = {
		
	    };
	}) cfg))
	(lib.mkIf (
	    (any (x: x == name) 
	    (lib.mapAttrsToList (host: conf: lib.attrValues (
		lib.mapAttrs 
		    (key: val: conf.l.vm.${key}.failoverMigration.backupHost)
		cfg)) 
	    nodes)
	) (lib.mapAttrs (vm-name: val: l.vm.${vm-name} = {
	    enable = true;
	    extraConfig = {
		systemd.services.failoverMigrationPoll = {
		    enable = true;
		    serviceConfig = {
			DynamicUser = "yes";
			AmbientCapabilities = [ "CAP_NET_RAW" "CAP_NET_ADMIN" ];
		    };
		    confinement.enable = true;
		    wants = [ "networking.target" ];
		    wantedBy = [ "multi-user.target" "timers.target" ];
		    script = let
			ping = "${pkgs.inetutils}/bin/ping";
			hostName = config.microvm.vms.${vm-name}.networking.hostName;
			domain = config.microvms.vms.${vm-name}.networking.domain;
			fqdn = config.microvm.vms.${vm-name}.networking.fqdn;
		    in ''
			${ping} -c5 ${fqdn};
			if [[ $(printf '%d\n' $?) == 1 ]]
			then if [[ $(${ping} -c5 1.1.1.1; printf '%d\n' $? == 1) ]]
			    then #TODO activate networking of VM in hot standby
			    else
			    fi
			else
			fi
		    '';
		};
		systemd.timers.failoverMigrationPoll = {
		    enable = true;
		    wantedBy = [ "multi-user.target" ];
		    startLimitBurst = 1;
		    timerConfig = {
			Unit = "failoverMigrationPoll.service";
			OnStartupSec = "2min";
			OnUnitActiveSec = "2min";
		    };
		};
	    };
	};) cfg))
    ];
}
#TODO host/guest networking, VNC, cockpit, autostart, device passthrough, live migration
