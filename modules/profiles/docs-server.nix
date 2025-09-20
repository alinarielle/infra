{ config, ... }:
with config.l.lib;
{
  l.profiles.base.enable = true;
  l.services = enable [
    "syncthing"
    "firefox-sync"
    "radicale"
    "nextcloud"
    "immich"
    "forgejo"
  ];
}
