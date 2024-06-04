{config, lib, inputs, ...}: 
with lib; with builtins;
let 
    cfg = config.impermanence;
    opt = mkOption;
in {
    options.impermanence = with types; {
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
	    bits = 4096;
	    path = "/persist/secrets/ssh/ssh_host_rsa_key";
	    type = "rsa";
	}{
	    path = "/persist/etc/secrets/ssh_host_ed25519_key";
	    type = "ed25519";
	}{
	    path = "/persist/etc/secrets/initrd_ssh_host_ed25519_key";
	    type = "ed25519";
	}];
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
	    ] 
	    ++ mkIf cfg.desktop.enable ["/home" "/var/lib/bluetooth"]
	    ++ keep-dirs;
	    files = [
		"/etc/machine-id"
	    ] ++ keep-files;
	};

	fileSystems = {
	    "/" = mkIf cfg.impermanence.enable mkForce { 
		device = "none"; 
		fsType = "tmpfs"; 
		options = [ "defaults" "size=2G" "mode=755"]; 
	    };
	    "/persist".neededForBoot = mkIf cfg.impermanence.enable true;
	};
    };
}
