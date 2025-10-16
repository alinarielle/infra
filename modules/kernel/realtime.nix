{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages-rt;
}
