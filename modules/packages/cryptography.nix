{pkgs, ...}: {
    users.users.alina.packages = with pkgs; [
      pinentry
      tomb
      ssh-to-age
      sops
    ];
}
