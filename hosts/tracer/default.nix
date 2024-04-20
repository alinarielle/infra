{
    imports = [
	../../profiles/impermanence.nix
	./hardware-configuration.nix
    ];
    networking.hostName = "tracer";
    system.stateVersion = "23.11";
    networking.tempAddresses = "enabled";
    vm.meow.enable = true;
    deployment = {
	targetHost = "2a0e:8f02:f022:fe00:c3f:576:88d0:4f1f";
	targetUser = "alina";
	tags = [ "infra" ];
    };
}
