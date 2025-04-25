{inputs, pkgs, lib, ...}: let
  inherit (inputs) dns;
in {
  services.knot = {
    enable = true;
    package = pkgs.knot-dns;
    checkConfig = false;
    enableXDP = false;
    keyFiles = [];
    settings = {
      server = {
        listen = [ "::@53" "0.0.0.0@53" ];
      };
      zone = {
        domain = "alina.cx";
        storage = "/var/lib/knot/zones";
        file = dns.utils.writeZone ./alina.cx.nix;
      };
      log = {
        target = "syslog";
        any = "info";
      };
    };
  };
}
