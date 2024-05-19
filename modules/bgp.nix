{nodes, name, config, inputs, lib, pkgs, ...}: {
    options = {};
    config = {
	services.bird2 = {
	    enable = true;
	    config = ''
		log syslog all;
		protocol device {
		    
		}
		router id ${env.primaryIP.v4};

		protocol direct {
		    disabled;
		    ipv4;
		    ipv6;
		}
		protocol kernel {
		    ipv4 {
			export all;
		    };
		}
	    '';
	};
    };
}
