{ pkgs, ... }:
{
  home-manager.users.alina.qt = {
    enable = true;
    platformTheme.name = "kde6";
    style = {
      name = "Sweet Nova";
      package = pkgs.sweet-nova;
    };
  };
}
