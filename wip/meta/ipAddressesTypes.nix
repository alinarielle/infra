{lib, config, ...}:
with lib; with builtins;
{
    config = {
	lib.types.ipAddresses = let
	    base-type = {
	    };
	in rec {
	    any = base-type // {
		name = "any";
		description = "a type matching either an ipv4 or ipv6 address";
		check = (x: (ipv4.check x) || (ipv6.check x));
	    };
	    ipv4 = base-type // {
		name = "ipv4";
		description = "a type matching a ipv4 address";
		check = (x: );
	    };
	    ipv6 = base-type // {
		name = "ipv6";
		description = "a type matching a ipv6 address";
		check = (x: );
	    };
	};
    };
}
