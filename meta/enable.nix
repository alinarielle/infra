{lib, config, ...}: {
    config.l.lib.enable = list: lib.genAttrs 
	list 
	(name: 
	    ${name}.enable = true;
	)
    ;
}
