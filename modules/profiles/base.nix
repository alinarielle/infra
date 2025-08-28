{config, ...}: with config.l.lib; {
  l.sops.enable = true;
  l.autoUpgrade.enable = true;
  l.boot = enable ["systemd-boot"];
  l.packages = enable [
    "archive" 
    "base" 
    "cryptography"
    "filesystem"
    "miscellaneous"
    "networking"
    "coreutils"
  ];
  l.users.sudo.enable = true;
  l.users.alina = enable [
    "git"
    "home-manager"
    "ssh"
    "pgp"
    "nvim"
    "helix"
    "user"
    "nushell"
    "zsh"
    "newsboat"
    "ranger"
    "emacs"
    "rclone"
  ];
  l.users.root = enable [
    "home-manager"
    "ssh"
    "zsh"
  ];
  l.network = enable [
    "networkmanager"
    "time"
    "hostName"
    "domain"
    "congestion"
    "speed"
    "getPort"
    "sshd"
    "wireguard"
    "nginx"
    "proxychains"
  ];
}
