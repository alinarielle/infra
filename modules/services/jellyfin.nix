{lib, ...}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "alina";
    user = "alina";
    dataDir = "/home/alina/.local/state/jellyfin";
    cacheDir = "/home/alina/.cache/jellyfin";
    logDir = "/home/alina/log/jellyfin";
  };
  systemd.services.jellyfin.serviceConfig.TimeoutSec = lib.mkForce 0;
}
