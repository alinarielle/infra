{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with config.l.lib;
{
  users.users.alina.packages = with pkgs; [
    inputs.noctalia.packages.x86_64-linux.default
  ];
  l.media.torrent.enable = true;
  l.virtualization.waydroid.enable = true;
  l.profiles = enable [
    "base"
    "hardened"
  ];
  l.users.alina = enable [
    "sway"
    "icons"
    "zellij"
    "swayidle"
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
