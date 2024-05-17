{nodes, name, config, inputs, lib, pkgs, ...}: {
    options = {};
    config = {
	services.bird2 = {
	    enable = true;
	    config = ''
		
	    '';
	};
    };
}
