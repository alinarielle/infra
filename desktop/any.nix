{lib, config, ...}:
{
    options.l.desktop.any.enable = lib.mkEnableOption "any desktop";
    config.l.desktop.any.enable = if 
	(lib.any
	    (x: x) 
	    (lib.mapAttrsToList 
		(key: val: let attrs = (lib.filterAttrs (name: value: name != "any") val);
		    in attrs.enable) 
		config.l.desktop)) 
	then true else false;
}
