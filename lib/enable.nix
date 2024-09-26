{lib, ...}: list: lib.genAttrs 
    list 
    (name: 
	${name}.enable = true;
    )
