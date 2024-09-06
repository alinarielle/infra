{lib, config, ...}: {
    options.l = {
	lib = lib.mkOption {
	    type = lib.types.attrs;
	    default = {};
	};
	prelude = {
	    type = lib.types.attrs;
	    default = {};
	};
    };
    config = {
	l.prelude.llib = config.l.lib;
    };
}
