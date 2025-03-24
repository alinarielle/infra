{config, lib, inputs, name, ...}: {
  imports = [ 
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
  ];
  
  config = {
    warnings  = ["WARNING: Impermanence enabled for ${name}."];

    users.mutableUsers = false;
    
    services.openssh.hostKeys = [{
      path = "/persist/etc/ssh/id_rsa";
      type = "rsa";
      bits = 4096;
    }{
      path = "/persist/etc/ssh/id_ed25519";
      type = "ed25519";
    }
    #(lib.mkIf config.l.network.initrdUnlock.enable {
      #path = "/persist/secrets/${name}/sshd/initrd_ssh_host_ed25519.key";
      #type = "ed25519";
    #})
    #(lib.mkIf config.l.network.initrdUnlock.enable {
      #path = "/persist/secrets/${name}/sshd/initrd_ssh_host_rsa.key";
      #type = "rsa";
      #bits = 4096;
    #})
    ];
    #sops.age.sshKeyPaths = [ "/persist/secrets/ssh/ssh_host_ed25519_key" ];
    l.folders."/build" = {};
    nix.settings.build-dir = "/build";
    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist" = {
      hideMounts = false;
      directories = [
	"/var/log"
	"/var/lib/nixos"
	"/var/lib/btrfs"
	"/var/lib/bluetooth"
	"/etc/NetworkManager/system-connections"
      ];
      files = [
	"/etc/machine-id"
      ];
    };
  };
}
