{lib, config, nodes,...}:
with lib; with builtins;
{
    lib.types.host = lib.types.str // {
	check = let
	    nodes-list = attrNames nodes;
	    service-dir = attrNames (readDir (${./.} + "../services"));
	    service-list = 
		map 
		    (x: if hasSuffix ".nix" x 
			then ("vm-" + 
			    (head 
				(splitString ".nix" x)
			    )
			) 
			else x
		    ) 
		    (attrNames (readDir (${./.} + "../services"));
	    host-list = nodes-list ++ service-list;
	in (x: any (y: x == y) host-list);
    };
}
