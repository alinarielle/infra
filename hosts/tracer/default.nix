{
    imports = [
	../../common
	../../profiles/impermanence.nix
	./hardware-configuration.nix
    ];
    networking.hostName = "tracer";
    system.stateVersion = "23.11";
    deployment = {
	targetHost = "2a0e:8f02:f022:fe00:f7c2:36ee:cd7c:c8a7";
	targetUser = "alina";
	tags = [ "infra" "tracer" ];
    };
}
