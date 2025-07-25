{config, lib, opt, cfg, ...}: {
  opt = with lib.types; lib.mkOption { default = {}; type = attrsOf path; };
  l.users.alina.homeDir = genAttrs 
    (map 
      (path: "woof/home/alina/" + path) 
      [ 
        "docs" 
        "archive"
        "videos"
        "music"
        "notes"
        "src"
        "pics"
        "secrets.kdbx"
      ]
    ) 
    (path: "/home/alina/" + path);

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
 
  systemd.tmpfiles.settings."homeDir"."/home/alina/mnt/tigris".d = {
    user = "alina"; group = "alina"; type = "d"; age = "-"; mode = "0700";
  };

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
        mounts = {
          "woof/" = {
            enable = true;
            mountPoint = "/home/alina/mnt/tigris";
          };
        } // lib.mapAttrs (key: val: {
          mountPoint = val;
          enable = true;
        }) cfg;
        options = {
          #cache-dir = "/home/alina/.cache";
          vfs-cache-mode = "full";
          vfs-cache-max-age = "off";
          vfs-cache-max-size = "off";
          vfs-cache-min-free-space = "100GB";
          vfs-cache-poll-interval = "5s";
        };
        secrets = {
          password = config.sops.secrets.tigris_crypt_obscured_passphrase.path;
          password2 = config.sops.secrets.tigris_crypt_obscured_salt.path;
        };
      };
    };
  };
}
