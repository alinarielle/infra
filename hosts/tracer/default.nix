{lib, config, ...}: {
    imports = [
	./hardware-configuration.nix
    ];
    l.filesystems.impermanence.enable = true;
    system.stateVersion = "23.11";
    networking.tempAddresses = "enabled";
    deployment = {
	targetHost = "2a0e:8f02:f022:fe00:c3f:576:88d0:4f1f";
	targetUser = "alina";
	tags = [ "infra" ];
    };
    l.vm = (lib.meta.enable [
	"syncthing" "nextcloud"
    ]) // lib.recursiveUpdate {
	syncthing.extraConfig = {
	    meow.enable = true;
	};
    };
}
