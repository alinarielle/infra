{lib, config, pkgs, ...}: {
    options.l.kernel.lsm.apparmor = with lib.types {
	enable = lib.mkEnableOption "AppArmor Linux Security Module"

    };
    config = let
    cfg = config.l.kernel.lsm.apparmor;
    in lib.mkIf config.l.kernel.lsm.apparmor.enable {
	security.apparmor = {
	    enable = true;
	    killUnconfinedConfinables = true;
	    
	};
    };
}
