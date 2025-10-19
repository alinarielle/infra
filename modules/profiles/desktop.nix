{ config, lib, ... }:
with config.l.lib;
{
  users.users.alina.packages = [pkgs.spotify];
  l.media.torrent.enable = true;
  l.virtualization.waydroid.enable = true;
  l.profiles = enable [
    "base"
    "hardened"
  ];
  l.users.alina = enable [
    "sway"
    "swaylock"
    "waybar"
    "audio"
    "bluetooth"
    "cursor"
    "fonts"
    "home-manager"
    "hyfetch"
    "kitty"
    "mime"
    "librewolf"
    "mako"
    "printing"
    "nix-daemon"
    "theme"
    "wayland"
    "zathura"
    "music"
    "swww"
    "kanshi"
  ];
}
