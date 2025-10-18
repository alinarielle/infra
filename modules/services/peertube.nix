{config, pkgs, ...}: {
  networking.extraHosts = ''
  127.0.0.1 watch.alina.dog
'';

  sops.secrets.peertube = {owner = "alina";};
  sops.secrets.peertubeRedis = {owner = "alina";};
  sops.secrets.peertubePostgres = {owner = "alina";};

  services = {
    peertube = {
      enable = true;
      user ="alina";
      secrets.secretsFile = config.sops.secrets.peertube.path;
      localDomain = "watch.alina.dog";
      enableWebHttps = false;
      database = {
        host = "127.0.0.1";
        name = "peertube_local";
        user = "peertube_test";
        passwordFile = config.sops.secrets.peertubePostgres.path;
      };
      redis = {
        host = "127.0.0.1";
        port = 31638;
        passwordFile = config.sops.secrets.peertubeRedis.path;
        #createLocally = true;
      };
      #smtp.createLocally = true;
      settings = {
        listen.hostname = "0.0.0.0";
        instance.name = "PeerTube Test Server";
        storage = {
          logs = "/opt/data/peertube/storage/logs/";
          cache = "/home/alina/.cache/peertube/";
        };
        log = {
          level = "debug";
        };
      };
    };

    postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = ''
        hostnossl peertube_local peertube_test 127.0.0.1/32 md5
      '';
      initialScript = pkgs.writeText "postgresql_init.sql" ''
        CREATE ROLE peertube_test LOGIN PASSWORD 'test123';
        CREATE DATABASE peertube_local TEMPLATE template0 ENCODING UTF8;
        GRANT ALL PRIVILEGES ON DATABASE peertube_local TO peertube_test;
        \connect peertube_local
        CREATE EXTENSION IF NOT EXISTS pg_trgm;
        CREATE EXTENSION IF NOT EXISTS unaccent;
      '';
    };

    redis.servers.peertube = {
      enable = true;
      bind = "0.0.0.0";
      requirePassFile = config.sops.secrets.peertubeRedis.path;
      port = 31638;
    };
  };
}
