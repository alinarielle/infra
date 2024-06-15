{config, ...}: {
    boot.initrd = {
	network.enable = true;
	luks.forceLuksSupportInInitrd = true;
	network.ssh = {
	    enable = true;
	    hostKeys = [ "/persist/secrets/ssh/initrd/ssh_host_ed25519_key" ];
	    authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
	};
    };
}
