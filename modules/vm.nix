{pkgs, lib, config, inputs, ...}: {
    imports = [ inputs.microvm.nixosModules.host ];
    options.vm = lib.mkOption {
	    type = lib.types.attrsOf (lib.types.submodule {
		options = {
		    enable = lib.mkEnableOption "a VM";
		};
	    });
	    default = {};
	    description = lib.mdDoc ''
		Enables the VM wrapper for `vm.<service>`.
	    '';
    };
    config = let 
	cfg = config.vm;
	activated-vms = lib.mapAttrsToList (name: _value: name) cfg; # put the names of all submodules in config.options.vm in a list
	#prefxdVMs = map (service: "vm-" + service) activated-vms;
	vm-attrs = lib.genAttrs
			(lib.mapAttrsToList (name: _value: name) (builtins.readDir ../services)) 
			(x: import ../services/${x}); # generate an attrs for each service inside vm-attrs to avoid infinite recursion because imports cant depend on config.vm
    in lib.mkIf (cfg != {}) {
	microvm.vms = lib.genAttrs activated-vms (service: {
	    inherit pkgs;
	    config = {
		networking.hostName = "vm-" + service;
		microvm = {
		    hypervisor = "cloud-hypervisor";
		    shares = [{
			source = "/nix/store";
			mountPoint = "/nix/.ro-store";
			tag = "ro-store";
			proto = "virtiofs";
		    }];
		};
	    } // vm-attrs.${service + ".nix"};
	});
	# additional goals: host/guest-networking, announcing host names via dns, ssh auto-complete, VNC, networking unit tests, guest application unit tests, autostart handling, device passthrough, VM secret management
    };
}
