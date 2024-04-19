{inputs, ...}: {
    # backup host, preferrably off-site, WIP
    imports = [
	../../profiles/impermanence.nix
	../../network/initrd-unlock.nix
	inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];
    networking.hostName = "terra";
    system.stateVersion = "24.05";
    deployment = {
	targetHost = "terra.alina.cx";
	targetUser = "alina";
	tags = [ "infra" ];
    };
}
