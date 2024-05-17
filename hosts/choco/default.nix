{inputs, ...}: {
    imports = [
	./hardware-configuration.nix
	../../profiles/impermanence.nix
	../../profiles/desktop
	inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];
    nixpkgs.config.allowUnfree = true;
    system.stateVersion = "23.11";
    net.env.nat = true;
    deployment = {
	targetHost = "choco.infra.alina.cx";
	targetUser = "alina";
	tags = [ "infra" "desktop" ]; # setting the desktop tag will preserve the home dir
	allowLocalDeployment = true;
    };
}
