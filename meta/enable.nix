{lib, config, ...}: {
    lib.meta.enable = list: lib.genAttrs 
	list 
	(name: 
	    ${name}.enable = true;
	)
    ;
}
