{lib, config, ...}: {
    options.l.filesystem.hardening.sysctl.enable = lib.mkEnableOption "fs sysctl config";
    config = lib.mkIf config.l.filesystem.hardening.sysctl.enable {
	# mitigate some TOCTOU vulnerabilities
	"fs.protected_fifos" = 2;
	"fs.protected_hardlinks" = 1;
	"fs.protected_regular" = 2;
	"fs.protected_symlinks" = 1;
    };
}
