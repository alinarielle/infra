{
    # second Hypervisor, also WIP
    imports = [ 
	./hardware-configuration.nix 
	../../profiles/impermanence.nix
	../../network/initrd-unlock.nix
    ];
    networking.hostName = "flora";
    system.stateVersion = "24.05";
    deployment = { 
	targetHost = "flora.alina.cx";
	targetUser = "root";
	tags = [ "infra" ];
    };
}
