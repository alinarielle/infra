{ lib, ... }:
{
  security.acme = {
    acceptTerms = true;
    certs."auth.alina.dog" = {
      email = "alina@duck.com";
      validMinDays = 10;
      webroot = "/var/lib/acme/acme-challenge/";
      group = "keycloak";
    };
  };
  services.keycloak = {
    enable = true;

  };
}
