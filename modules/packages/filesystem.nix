{pkgs, ...}: let packages = with pkgs; [
  du-dust
  btrfs-progs
  fd
  tree
  lsd
  bat
  mdcat
  hexyl
  lsof
  ranger
  rsync
  rclone
]; in {
    users.users.alina.packages = packages;
    users.users.root.packages = packages;
}
