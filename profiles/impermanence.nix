{config, lib, ...}: {
    users.mutableUsers = false;
    services.openssh.hostKeys = [
	{
	    bits = 4096;
	    path = "/persist/secrets/ssh/ssh_host_rsa_key";
	    type = "rsa";
	}
	{
	    path = "/persist/etc/secrets/ssh_host_ed25519_key";
	    type = "ed25519";
	}
	{
	    path = "/persist/etc/secrets/initrd_ssh_host_ed25519_key";
	    type = "ed25519";
	}
    ];
    sops.age.sshKeyPaths = [ "/persist/secrets/ssh/ssh_host_ed25519_key" ];
    environment.persistence."/persist" = {
	hideMounts = true;
	directories = let
	    homeIfDesktop = if builtins.elem "desktop" config.deployment.tags 
		then [ "/home" ] else [];
	    in [
	    "/var/log"
	    "/var/lib/nixos"
	    "/var/lib/btrfs"
	    "/etc/NetworkManager/system-connections"
	    "/var/lib/bluetooth"
	    "/nix"
	    "/etc/nixos"
	] ++ homeIfDesktop;
	files = [
	    "/etc/machine-id"
	];
    };

    fileSystems."/".options = if ( builtins.hasAttr "persistence" config.environment ) 
	then lib.mkForce { device = "none"; fsType = "tmpfs"; options = [ "default" "size=2G" "mode=755"]; } else {};

    fileSystems."/persist".neededForBoot = if ( builtins.hasAttr "persistence" config.environment )
	then true else false;
}
