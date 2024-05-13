{
    imports = [
	./hardware-configuration.nix
    ];
    system.stateVersion = "23.11";
    deployment = {
	targetUser = "root";
	targetHost = "pa.lexi.re";
    };
    net.dns = {
	enable = true;
	primary = true;
	listen."45.150.123.35".port = 53;
    };
}
