{lib, config, ...}: list: lib.genAttrs 
    list 
    (name: 
	${name}.enable = true;
    )
