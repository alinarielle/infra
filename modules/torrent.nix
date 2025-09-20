{
  pkgs,
  config,
  lib,
  opt,
  cfg,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    flood
  ];

  sops.secrets.floodSecret = {
    sopsFile = ../secrets/global.yaml;
  };
  systemd.services.flood = {
    environment.FLOOD = "%d/floodSecret";
    serviceConfig = {
      DynamicUser = true;
      LoadCredential = "floodSecret:${config.sops.secrets.floodSecret.path}";
      ExecStart =
        "${pkgs.flood} "
        + lib.cli.toGNUCommandLineShell { } {
          qbuser = "alina";
          qbpass = "$FLOOD";
          qburl = "http://127.0.0.1:8080";
        };
    };
  };

  sops.secrets.autobrrSessionSecret = {
    sopsFile = ../secrets/global.yaml;
  };
  services.autobrr = {
    enable = true;
    secretFile = config.sops.secrets.autobrrSessionSecret.path;
    settings = {
      host = "127.0.0.1";
      port = 7474;
      checkForUpdates = false;
    };
  };

  sops.secrets.delugeAuthFile = {
    sopsFile = ../secrets/global.yaml;
    owner = "deluge";
  };
  services.deluge = {
    enable = true;
    web = {
      enable = true;
      openFirewall = true;
    };
    declarative = false;
    authFile = config.sops.secrets.delugeAuthFile.path;
    openFirewall = true;
  };
  services.qbittorrent = {
    enable = true;
    webuiPort = 8080;
    torrentingPort = 52189;
    #package = pkgs.qbittorrent-enhanced;
    user = "alina";
    serverConfig = {
      LegalNotice.Accepted = true;
      Preferences = {
        WebUI = {
          Username = "alina";
          Password_PBKDF2 = "fbIIGk8R14J3PqW2l6ajGA==:vxf2o13GNB+re9d0drkEZNqVv43bPFnxnMcGFXwfh9XB+n1P21DOQ7nck6lina5t+MITFdqAy1hjQBBiKyfAcA==";
        };
      };
      BitTorrent = {
        MergeTrackersEnables = true;
        Session = {
          AddTrackersFromURLEnabled = true;
          AdditionalTrackersURL = true;
          AnonymousModeEnabled = true;
          DefaultSavePath = "/tmp/woof/";
          DisableAutoTMMByDefault = false;
          MaxActiveCheckingTorrents = -1;
          MaxConnections = -1;
          MaxConnectionsPerTorrent = -1;
          MaxUploads = -1;
          MaxUploadsPerTorrent = -1;
          Port = 52189;
          QueueingSystemEnabled = false;
          SSL.Port = 2101;
          StartPaused = false;
          Tags = "flac";
          TorrentContentLayout = "Subfolder";
          TorrentExportDirectory = "/tmp/woof/";
          UseUnwantedFolder = true;
        };
      };
      Core.AutoDeleteAddedTorrentFile = "Never";
      Preferences = {
        Downloads.ScanDirsLastPath = "/home/alina/Downloads";
      };
      RSS = {
        AutoDownloader = {
          EnableProcessing = true;
          DownloadRepacks = true;
        };
        Session = {
          EnableProcessing = true;
          RefreshInterval = 10;
        };
      };
    };
  };
}

#write nushell handler for torrents finished downloading
#write nushell handler for firefox that sorts stuff into s3 buckets
# dont run as my user but as stateless systemd service with tasks.nix and rclone.nix
