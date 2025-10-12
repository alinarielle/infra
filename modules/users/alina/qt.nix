{ pkgs, ... }:
{
  home-manager.users.alina.qt = {
    enable = true;
    platformTheme.name = "kde6";
    style = {
      name = "sweet";
      package = pkgs.sweet-nova;
    };
  };
}
