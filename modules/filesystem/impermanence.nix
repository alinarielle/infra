{config, lib, inputs, name,...}: 
with lib; with builtins;
let 
    cfg = config.l.filesystems.impermanence;
    opt = mkOption;
in {
    imports = [ inputs.impermanence.nixosModules.impermanence ];
    options.l.filesystems.impermanence = with types; {
	enable = mkEnableOption "impermanence";
	keep = opt { type = listOf str; default = []; };
    };
    config = 
    let
	keep-dirs = filter (x: readFileType x == "directory") cfg.keep;
	keep-files = filter (x: readFileType x == "regular") cfg.keep;
    in 
    mkIf cfg.enable {
	warnings  = ["WARNING: Impermanence enabled for ${name}."];
	users.mutableUsers = false;
	services.openssh.hostKeys = [{
	    path = "/persist/secrets/${name}/sshd/ssh_host_rsa.key";
	    type = "rsa";
	    bits = 4096;
	}{
	    path = "/persist/secrets/${name}/sshd/ssh_host_ed25519.key";
	    type = "ed25519";
	}(mkIf config.l.network.initrdUnlock.enable {
	    path = "/persist/secrets/${name}/sshd/initrd_ssh_host_ed25519.key";
	    type = "ed25519";
	})
	(mkIf config.l.network.initrdUnlock.enable {
	    path = "/persist/secrets/${name}/sshd/initrd_ssh_host_rsa.key";
	    type = "rsa";
	    bits = 4096;
	})];
	sops.age.sshKeyPaths = [ "/persist/secrets/ssh/ssh_host_ed25519_key" ];
	environment.persistence."/persist" = {
	    hideMounts = true;
	    directories = [
		"/var/log"
		"/var/lib/nixos"
		"/var/lib/btrfs"
		"/etc/NetworkManager/system-connections"
		"/nix"
		"/etc/nixos"
		"/boot"
		"/secrets"
	    ] 
	    ++ mkIf cfg.desktop.enable ["/home" "/var/lib/bluetooth"]
	    ++ keep-dirs;
	    files = [
		"/etc/machine-id"
	    ] ++ keep-files;
	};

	fileSystems = {
	    "/" = mkForce { 
		device = "none"; 
		fsType = "tmpfs"; 
		options = [ "defaults" "size=2G" "mode=755"]; 
	    };
	    "/persist".neededForBoot = true;
	};
    };
}
#persist secrets mgmt
