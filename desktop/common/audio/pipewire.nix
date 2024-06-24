{lib, config, ...}:
with lib; with builtins;
let
    cfg = config.pipewire;
    opt = mkOption;
in
{
    options.pipewire = {
	extraConfig.pipewire = {
	    client = {
		
	    };
	};
	wireplumber.extraConfig = {};
    };
}
