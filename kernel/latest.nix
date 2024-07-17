{lib, config, pkgs, ...}: {
    options.l.kernel.latest.enable = lib.mkEnableOption "install the latest kernel";
    config = lib.mkIf config.l.kernel.latest.enable {
	boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
