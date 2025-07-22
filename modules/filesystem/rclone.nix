{config, ...}: {
  sops.secrets.tigris_access_key_id = { 
    owner = "alina";
    sopsFile = ../../secrets/global.yaml;
  };
  sops.secrets.tigris_secret_access_key = { 
    owner = "alina";
    sopsFile = ../../secrets/global.yaml;
  };
  home-manager.users.alina.programs.rclone = {
    enable = true;
    remotes = {
      tigris = {
        config = {
          type = "s3";
          provider = "other";
          endpoint = "https://t3.storage.dev";
        };
        mounts."woof/" = {
          enable = true;
          mountPoint = "/home/alina/mnt/tigris";
        };
        secrets = {
          secret_access_key = config.sops.secrets.tigris_secret_access_key.path;
          access_key_id = config.sops.secrets.tigris_access_key_id.path;
        };
      };
    };
  };
}
