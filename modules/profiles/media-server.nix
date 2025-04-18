{config, ...}: with config.l.lib; {
  l.profiles = enable ["base"];
  l.services = enable [
    "bazarr"
    "calibre"
    "jackett"
    "jellyfin"
    "jellyseerr"
    "magnetico"
    "navidrome"
    "qbittorrent"
    "radarr"
    "sonarr"
    "soulseek"
    "tdarr"
    "unpackerr"
  ];
}
