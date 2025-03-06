{srv, pkgs, lib, ...}: {
  srv.exec = [
    "${lib.getExe pkgs.radarr}"
  ];
}
