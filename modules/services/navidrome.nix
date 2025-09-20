{
  pkgs,
  config,
  srv,
  opt,
  cfg,
  lib,
  name,
  ...
}:
let
  ndcfg = with config.l.network.lib; {
    LogLevel = "info";
    MusicFolder = "/var/lib/navidrome/music";
    DataFolder = "/var/lib/navidrome";
    CacheFolder = "/var/cache/navidrome";

    Address = "localhost"; # configure reverse proxy
    Port = getPort "navidrome";
    BaseUrl = "";
    "HTTPSecurityHeaders.CustomFrameOptionsValue" = "DENY";
    "ReverseProxyUserHeader" = "Remote-User";
    "ReverseProxyWhitelist" = ""; # empty => deny all

    DefaultDownsamplingFormat = "opus";
    EnableDownloads = true;
    EnableGravatar = false;

    EnableSharing = false;
    ShareURL = ""; # empty => use server address

    "Jukebox.Enabled" = cfg.jukebox;
    "Jukebox.AdminOnly" = !cfg.jukebox;
    "Jukebox.Devices" = ""; # empty => auto detect
    "Jukebox.Default" = ""; # empty => auto detect

    EnableExternalServices = true;

    "LastFM.Enabled" = false;
    "LastFM.ApiKey" = "";
    "LastFM.Secret" = "";

    "ListenBrainz.Enabled" = false;

    "PasswordEncryptionKey" = ""; # TODO

    "Prometheus.Enabled" = cfg.prometheus;

    "Spotify.ID" = "";
    "Spotify.Secret" = "";

    TLSCert = "";
    TLSKey = "";
  };
  json = pkgs.formats.json;
in
{
  opt = {
    jukebox = lib.mkEnableOption "enable audio playback on the server hardware";
    prometheus = lib.mkEnableOption "enable prometheus integration";
  };
  environment.systemPackages = with pkgs; lib.optional cfg.jukebox [ mpv ];
  networking.firewall.allowedTCPPorts = [ ndcfg.Port ];
  srv.script = "${lib.getExe pkgs.navidrome} --configfile ${json.generate "cfg.json" ndcfg}";
  srv.intranet = true;
  srv.paths.rw = [ ndcfg.Musicfolder ];
  srv.paths.exec = "${lib.getExe pkgs.navidrome}";
}
#TODO jukebox (with JACK?) https://www.navidrome.org/docs/usage/jukebox/#configuration
#TODO reverseproxy https://www.navidrome.org/docs/usage/security/#reverse-proxy-authentication
#TODO prometheus
#TODO spotify integration https://www.navidrome.org/docs/usage/external-integrations/#spotify
#TODO sops secrets management
#TODO ACME cert
#TODO intranet wireguard auto generation
#TODO DNS
