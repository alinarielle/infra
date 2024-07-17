{lib, config, ...}: {
    imports = [
	./sysctl.nix
    ];
    options.l.network.hardening.enable = lib.mkEnableOption "hardened network config";
    config = lib.mkIf config.l.network.hardening.enable {
	l.network.hardening.sysctl.enable = true;
    };
}
