{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.rclone.nixosModules.default ];
  sops.secrets =
    lib.genAttrs
      [
        "tigris_access_key_id"
        "tigris_secret_access_key"
        "tigris_crypt_obscured_passphrase"
        "tigris_crypt_obscured_salt"
      ]
      (secret: {
        owner = "alina";
      });
  rclone.enable = true;
  rclone.mounts."/home/alina/music" = {
    user = "alina";
    remotes = [
      {
        type = "crypt";
        flags = {
          crypt-password = config.sops.secrets.tigris_crypt_obscured_passphrase.path;
          crypt-password2 = config.sops.secrets.tigris_crypt_obscured_salt.path;
          crypt-remote = "tigris:woof/";
        };
      }
      {
        type = "s3";
        name = "tigris";
        flags = {
          s3-access-key-id = config.sops.secrets.tigris_access_key_id.path;
          s3-secret-access-key = config.sops.secrets.tigris_secret_access_key.path;
          s3-endpoint = "t3.storage.dev";
          s3-provider = "Other";
        };
      }
    ];
  };
}
