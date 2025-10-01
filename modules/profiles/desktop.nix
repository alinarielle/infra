{ config, lib, ... }:
with config.l.lib;
{
  l.profiles = enable [
    "base"
    "hardened"
  ];
  l.users.alina = enable [
    "niri"
    "sway"
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
