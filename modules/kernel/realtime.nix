{pkgs, cfg,...}: {
    boot.kernelPackages = pkgs.linuxPackages-rt;
}
