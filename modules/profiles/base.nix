{config, ...}: with config.l.lib; {
  l.boot = enable ["systemd-boot"];
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
    "user"
    "nushell"
    "zsh"
    "newsboat"
    "kakoune"
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
  ];
}
