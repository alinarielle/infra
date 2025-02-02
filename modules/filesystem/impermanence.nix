{config, lib, inputs, name, cfg, opt, ...}: {
  imports = [ 
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
  ];
    
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
    disko.devices.nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
	"size=2G"
	"defaults"
	"mode=755"
      ];
    };
    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
	"/var/log"
	"/var/lib/nixos"
	"/var/lib/btrfs"
	"/etc/NetworkManager/system-connections"
	"/nix/store"
	"/secrets"
	"/home"
      ] 
      ++ lib.optional config.l.desktop.common.bluetooth.enable ["/var/lib/bluetooth"]
      ++ keep-dirs;
      files = [
	"/etc/machine-id"
      ] ++ keep-files;
    };
  };
}
