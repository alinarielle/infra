{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages-libre;
}
