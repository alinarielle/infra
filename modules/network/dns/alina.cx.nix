{inputs, ...}: let
  inherit (inputs) dns;
in {
  SOA = {
    nameServer = "ns1.alina.cx";
    adminEmail = "alina@duck.com";
    serial = 202504121005;
  };
  useOrigin = false;
  NS = [
    "ns1.alina.cx."
    "ns2.alina.cx."
  ];
  A = [];
  AAAA = [];
  subdomains = {};
}
