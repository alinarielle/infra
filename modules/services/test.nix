{ srv, pkgs, ... }:
{
  srv.script = "${pkgs.inetutils/bin/ping} nixos.org";
  srv.paths.exec = [ "${pkgs.inetutils}/bin/ping" ];
  srv.persist = false;
}
