{
    # second Hypervisor, also WIP
    imports = [ 
	./hardware-configuration.nix 
	../../profiles/impermanence.nix
	../../common
	../../network/initrd-unlock.nix
    ];
    networking.hostName = "snow";
    system.stateVersion = "24.05";
    deployment = { 
	targetHost = "snow.alina.cx";
	targetUser = "root";
	tags = [ "infra" ];
    };
}
