{pkgs, ...}: let packages = with pkgs; [
  p7zip
  zstd
  unzip
  ouch
]; in {
    users.users.alina.packages = packages;
    users.users.root.packages = packages;
}
