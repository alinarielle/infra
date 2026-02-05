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
  l.profiles = enable [
    "base"
  ];
  l.kernel.latest.enable = true;
  l.users.alina = enable [
    "sway"
    "packages"
    "icons"
    "zellij"
    "packages"
    "swayidle"
    "audio"
    "bluetooth"
    "cursor"
    "fonts"
    "home-manager"
    "hyfetch"
    "kitty"
    "mime"
    "librewolf"
    "nix-daemon"
    "theme"
    "wayland"
    "zathura"
    "swww"
    "kanshi"
  ];
}
