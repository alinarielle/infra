{config, ...}: with config.l.lib; {
  l.boot = enable ["systemd-boot"];
  l.packages = enable [
    "archive" 
    "base" 
    "chat" 
    "cryptography"
    "development"
    "filesystem"
    "miscellaneous"
    "networking"
    "pentesting"
  ];
  l.users.alina = enable [
    "git"
    "home-manager"
    "ssh"
    "pgp"
    "nvim"
    "user"
    "nushell"
    "emacs"
    "newsboat"
  ];
  l.users.root = enable [
    "home-manager"
    "ssh"
    "zsh"
  ];
  l.network = enable [
    "networkmanager"
    "mullvad"
    "time"
    "hostName"
    "domain"
    "congestion"
    "speed"
    "getPort"
    "sshd"
  ];
}
