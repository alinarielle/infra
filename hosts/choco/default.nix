{inputs, lib, config, ...}: with lib.meta; {
    imports = [
	./hardware-configuration.nix
	inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];
    system.stateVersion = "24.05";
    l.filesystems = enable [ "impermanence" ];
    l.desktop = enable [ "impermanence" "sway" ];
    l.meta.profiles = enable [ "hardened" "monitoring-export" "base" ];
}
