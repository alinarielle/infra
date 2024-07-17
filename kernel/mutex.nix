{lib, config, ...}: {
    config = {
	assertions = let
	    enabledKernels = lib.mapAttrsToList (key: val: 
		(lib.mkIf val.enable key)
	    ) (filterAttrs (name: value: builtins.any (x: 
		x == name
	    ) [ "hardened" "latest" "lts" "rt-xanmod" "rt-zen" ]) config.l.kernel); 
	in [
	    (lib.mkIf 
		((lib.length enabledKernels) >= 2)
		"You can't activate more than one kernel at the same time!"
	    )
	];
    };
}
