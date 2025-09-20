{ pkgs, ... }:
let
  packages = with pkgs; [
    du-dust
    btrfs-progs
    inotify-tools
    glow
    fd
    tree
    lsd
    bat
    hexyl
    lsof
    ranger
    rsync
    rclone
  ];
in
{
  users.users.alina.packages = packages;
  users.users.root.packages = packages;
}
