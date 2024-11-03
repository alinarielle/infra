{config, lib, inputs, name, cfg, opt, ...}: {
  imports = [ inputs.impermanence.nixosModules.impermanence ];
    
  opt.keep = with lib.types; lib.mkOption { type = listOf str; default = []; };
  
  config = let
    keep-dirs = lib.filter (x: lib.readFileType x == "directory") cfg.keep;
    keep-files = lib.filter (x: lib.readFileType x == "regular") cfg.keep;
  in {
    warnings  = ["WARNING: Impermanence enabled for ${name}."];

    users.mutableUsers = false;

    services.openssh.hostKeys = [{
      path = "/persist/secrets/${name}/sshd/ssh_host_rsa.key";
      type = "rsa";
      bits = 4096;
    }{
      path = "/persist/secrets/${name}/sshd/ssh_host_ed25519.key";
      type = "ed25519";
    }(lib.mkIf config.l.network.initrdUnlock.enable {
      path = "/persist/secrets/${name}/sshd/initrd_ssh_host_ed25519.key";
      type = "ed25519";
    })
    (lib.mkIf config.l.network.initrdUnlock.enable {
      path = "/persist/secrets/${name}/sshd/initrd_ssh_host_rsa.key";
      type = "rsa";
      bits = 4096;
    })];
    #sops.age.sshKeyPaths = [ "/persist/secrets/ssh/ssh_host_ed25519_key" ];
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
	"/home"
      ] 
      ++ lib.mkIf (lib.elem "desktop" config.deployment.tags) ["/var/lib/bluetooth"]
      ++ keep-dirs;
      files = [
	"/etc/machine-id"
      ] ++ keep-files;
    };

    fileSystems = {
      "/" = lib.mkForce { 
	device = "none"; 
	fsType = "tmpfs"; 
	options = [ "defaults" "size=2G" "mode=755"]; 
      };
      "/persist".neededForBoot = true;
    };
  };
}
# TODO persistent secrets mgmt
