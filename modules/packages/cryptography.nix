{pkgs, ...}: {
    users.users.alina.packages = with pkgs; [
      pinentry
      yubikey-manager
      tomb
      ssh-to-age
      sops
    ];
}
