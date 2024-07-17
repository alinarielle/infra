{lib, config, ...}: lib.mkMerge [{
    imports = [
	./noDefaultPackages.nix
    ];
} // lib.mkLocalModule ./. "packages hardening toggle interface" {
    l.packages.hardening.noDefaultModules.enable = true;
}]
