{lib, config, ...}:
with lib; with builtins;
let
    cfg = config.l.network.getAddress;
    opt = mkOption;
in
{
    options.l.network.getAddress = with types; {
	default = {};
	type = attrsOf (submodule {
	    options = with ipAddresses; rec {
		addressType = opt { type = attrs; default = ipv6; };
		networkSize = opt { 
		    type = cidrPrefix; 
		    default = if addressType == ipv6 then "/64" else "/32";
		};
		routingPrefix = opt { 
		    type = oneOf [ ipv4 ipv6 ]; 
		    default = if addressType == ipv6 then "10.0.0.0"; 
		};
	    };
	});
    };
    config = {
	lib.network.getAddress = args@{
	    addressType ? types.ipAddresses.ipv6, 
	    size ? "/32",
	    id,
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
