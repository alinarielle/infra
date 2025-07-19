{srv, pkgs, lib, ...}: {
  environment.systemPackages = with pkgs; [ flood ];
  srv.exec = [
    "${lib.getExe pkgs.qbittorrent}"
  ];
}
