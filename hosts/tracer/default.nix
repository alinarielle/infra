{
    imports = [
	./hardware-configuration.nix
    ];
    impermanence.enable = true;
    system.stateVersion = "23.11";
    networking.tempAddresses = "enabled";
    deployment = {
	targetHost = "2a0e:8f02:f022:fe00:c3f:576:88d0:4f1f";
	targetUser = "alina";
	tags = [ "infra" ];
    };
}
