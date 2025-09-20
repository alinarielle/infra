{ config, lib, ... }:
with config.l.lib;
{
  l.profiles = enable [
    "base"
    "hardened"
  ];
  l.podman.enable = true;
  l.torrent.enable = true;
  l.desktop.common.music.enable = true;
  l.desktop.sway = enable [
    "config"
    "swaylock"
    "waybar"
  ];
  l.desktop.niri = enable [ "config" ];
  l.kernel.hardenedLibre.enable = lib.mkForce false;
  l.packages = enable [
    "development"
    "pentesting"
    "chat"
  ];
  l.network = enable [ "mullvad" ];
}
