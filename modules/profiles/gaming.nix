{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.steam ];
  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;
}
