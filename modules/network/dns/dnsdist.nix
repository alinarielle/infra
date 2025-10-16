{ lib, pkgs, ... }:
let
  format = pkgs.formats.yaml;
in
{
  services.dnsdist = {
    enable = true;
    listenPort = 53;
    listenAddress = "::1";
    extraConfig = ''

    '';
  };
}
