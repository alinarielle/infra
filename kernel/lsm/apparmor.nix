{lib, config, pkgs, ...}: {
    options.l.kernel.lsm.apparmor = with lib.types {
    };
} // config.l.lib.mkLocalModule ./apparmor.nix "AppArmor security module" {
    security.apparmor = {
	enable = true;
	killUnconfinedConfinables = true;  
    };
}
