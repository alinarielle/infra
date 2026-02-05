{ config, ... }:
with config.l.lib;
{
  l.home.enable = true;
  l.nix.enable = true;
  l.boot = enable [ "systemd-boot" ];
  l.authentication.sudo.enable = true;
  l.kernel.latest.enable = true;
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
    "ranger"
    "starship"
  ];
  l.users.root = enable [
    "home-manager"
    "ssh"
    "zsh"
    "user"
  ];
  l.network = enable [
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
    "networkmanager"
  ];
}
