{
  ...
}:
{
  #sops.secrets.immichPostgres = { };
  services.immich = {
    enable = true;
    #secretsFile = config.sops.secrets.immichPostgres.path;
  };
}
