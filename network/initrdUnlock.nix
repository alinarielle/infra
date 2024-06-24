{lib, config, name,...}: 
with lib; with builtins;
{
    options.l.network.initrdUnlock.enable = 
	mkEnableOption "Authentication in the initramfs";
    config = mkIf config.l.network.initrdUnlock.enable {
	boot.initrd = {
	    systemd = {
		enable = true;
		#connect to rp-mesh, never expose ssh to clearnet
	    };
	    luks.mitigateDMAAttacks = true;
	    network = {
		enable = true;
		flushBeforeStage2 = true;
		ssh = {
		    enable = true;
		    port = 22;
		    hostKeys = [ 
			"/secrets/${name}/sshd/initrd_ssh_host_ed25519.key"
			"/secrets/${name}/sshd/initrd_ssh_host_rsa.key"
		    ]; #TODO generate, secrets mgmt in general
		    authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
		};
	    };
	};
    };
}
