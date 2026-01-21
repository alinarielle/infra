{ config, ... }:
with config.l.lib;
{
  l.home.enable = true;
  l.nix.enable = true;
  l.autoUpgrade.enable = true;
  l.boot = enable [ "systemd-boot" ];
  l.authentication.sudo.enable = true;
  l.users.alina = enable [
    "git"
    "home-manager"
    "ssh"
    "pass"
    "pgp"
    "nvim"
    "user"
    "nushell"
    "zsh"
    "newsboat"
    "ranger"
    "emacs"
    # "rclone"
    "starship"
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
    "hosts"
    "mullvad"
  ];
}
