{
    # Hypervisor, WIP
    imports = [ 
	./hardware-configuration.nix 
	../../profiles/impermanence.nix
	../../common
	../../network/initrd-unlock.nix
    ];
    networking.hostName = "snow";
    system.stateVersion = "xx.xx";
    deployment = { 
	targetHost = "snow.alina.cx";
	targetUser = "root";
	tags = [ "infra" ];
    };
}
