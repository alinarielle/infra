{config, ...}: with config.l.lib; {
  l.sops.enable = true;
  l.boot = enable ["systemd-boot"];
  l.filesystem = enable [
    "rclone"
  ];
  l.packages = enable [
    "archive" 
    "base" 
    "cryptography"
    "filesystem"
    "miscellaneous"
    "networking"
  ];
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
