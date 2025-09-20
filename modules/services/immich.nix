{
  srv,
  pkgs,
  lib,
  config,
  ...
}:
{
  services.immich = {
    enable = true;
    secretsFile = config.sops.secrets.immich_db.path;
  };
  l.db.ensure.immich = { };
  sops.secrets.immich_db = { };
}
