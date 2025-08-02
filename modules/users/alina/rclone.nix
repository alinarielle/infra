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

  multi-homed.alina = {
    s3 = {
      enable = true;
      accessKey = config.sops.secrets.tigris_access_key_id.path;
      secretAccessKey = config.sops.secrets.tigris_secret_access_key.path;
      encryptedRemotePassphrase = config.sops.secrets.tigris_crypt_obscured_passphrase.path;
      encryptedRemoteSalt = config.sops.secrets.tigris_crypt_obscured_salt.path;
      bucketName = "woof";
      provider = "Other";
      type = "s3";
      endpoint = "https://t3.storage.dev";
    };
  };
}
