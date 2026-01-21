{
  services.paperless = {
    enable = true;
    configureTika = true;
    dataDir = /var/lib/paperless/data;
    database.createLocally = true;
    domain = "paperless.local";
  };
}
