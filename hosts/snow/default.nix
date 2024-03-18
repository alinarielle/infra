{
    imports = [ 
	./hardware-configuration.nix 
	../../profiles/impermanence.nix
	../../users
	../../common
	../../network/initrd-unlock.nix
    ];
    networking.hostName = "snow";
    networking.hostId = "a2047730";
    system.stateVersion = "24.05";
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    time.timeZone = "Europe/Berlin";
    deployment = { 
	targetHost = "116.202.196.50";
	targetUser = "root";
	tags = [ "infra" ];
    };
}
