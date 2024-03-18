{inputs, ...}: {
    imports = [
	./hardware-configuration.nix
	../../profiles/impermanence.nix
	../../common
	../../profiles/desktop
	inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];
    networking.hostName = "choco";
    system.stateVersion = "23.11";
    deployment = {
	targetHost = "choco.infra.alina.cx";
	targetUser = "alina";
	tags = [ "infra" "desktop" ]; # setting the desktop tag will preserve the home dir
	allowLocalDeployment = true;
    };
}
