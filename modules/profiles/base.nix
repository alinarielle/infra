{ config, ... }:
with config.l.lib;
{
  l.nix.enable = true;
  l.home.enable = true;
  # l.iso.enable = true;
  l.sops.enable = true;
  l.autoUpgrade.enable = true;
  l.boot = enable [ "systemd-boot" ];
  l.packages.enable = true;
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
    "rclone"
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
