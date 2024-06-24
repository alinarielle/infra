{lib, config, ...}:
with lib; with builtins;
let
    cfg = config.l.network.getAddress;
    opt = mkOption;
in
{
    options.l.network.getAddress = with types; {
	registry = opt {
	    default = {};
	    type = attrsOf (submodule {
		options = {
		    alloc = opt {
			default = [];
			type = listOf with ipAddresses; oneOf [ v4 v6 ];
		    };
		};
	    });
	};
    };
    config = {
	lib.network.getAddress = args@{
	    type ? types.ipAddresses.v6, 
	    size ? (if type = types.ipAddresses.v4 then "/32" else "/64"),
	    ...}:
	let
	    argsl = attrNames args;
	    hosts = filterAttrs 
		(key: val: all 
		    (host: ${key} != ${host}) 
		    attrNames nodes) 
		args;
	    hostsl = attrNames hosts;
	    count = length hostsl;
	in
	
	;
    };
}
