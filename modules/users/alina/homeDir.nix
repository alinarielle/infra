{config, lib, ...}: {
  sops.secrets = lib.genAttrs 
    [
      "tigris_access_key_id"
      "tigris_secret_access_key"
      "tigris_crypt_obscured_passphrase"
      "tigris_crypt_obscured_salt"
    ]
    (secret: { 
      owner = "alina"; 
      sopsFile = ../../secrets/global.yaml; 
    });
  home-manager.users.alina.programs.rclone = {
    enable = true;
    remotes = {
      tigris = {
        config = {
          type = "s3";
          provider = "Other";
          endpoint = "https://t3.storage.dev";
        };
        secrets = {
          secret_access_key = config.sops.secrets.tigris_secret_access_key.path;
          access_key_id = config.sops.secrets.tigris_access_key_id.path;
        };
      };
      tigris_crypt = {
        config = {
          type = "crypt";
          remote = "tigris:woof/";
        };
        mounts."woof/" = {
          enable = true;
          mountPoint = "/home/alina/mnt/tigris";
        };
        secrets = {
          password = config.sops.secrets.tigris_crypt_obscured_passphrase.path;
          password2 = config.sops.secrets.tigris_crypt_obscured_salt.path;
        };
      };
    };
  };
}
