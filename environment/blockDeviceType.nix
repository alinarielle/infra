{lib, config, ...}:
with lib; with builtins; let
    opt = mkOption;
in {
    options.lib.types.blockDevice = opt { type = attrs; default = {}; };
    config = {
	lib.types.blockDevice = mkOptionType {
	    name = "Block Device";
	    description = ''a type-checked attribute set for storing information such as
			    size, identifiers, storage type (SSD or HDD), connection
			    type (NVME, SATA), read and write speed'';
	    emptyValue = { value = { ids = {};};};
	    check = let
	    l = [
		"readSpeed"
		"writeSpeed"
		"capacity"
		"storageType"
		"ids"
	    ];
	    in (x: 
		if 
		    (isAttrs x)
		    &&
		    (all
			true
			map 
			    (y: 
				elem 
				    y 
				    l
			    )
			    attrNames x
		    ) l;
		    &&
		    hasAttr "ids" x
		    &&
		    typeOf x.ids == "set"
		    &&
		    all (z:
			if
			    hasAttr ${z} x
			then
			    if 
				typeOf x.${z} == "string"
			    then true
			    else false
			else true
		    )
		    (filter (z: a != "ids") l)
	    ); # assert that blockdevice contains no other attributes than the specified
	       # ones and necessarily contains the attribute "ids" which is an attrs
	       # and that the blockdevice is an attrs itself
	};
    };
}
