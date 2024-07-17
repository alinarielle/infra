{pkgs ? import inputs.nixpkgs-2405 {}, lib, config, ...}: {
    options.l.kernel.stable.enable = lib.mkEnableOpton "latest stable linux kernel";
    config = lib.mkIf config.l.kernel.stable.enable {
	boot.kernelPackages = pkgs.linuxPackages;
    };
}
