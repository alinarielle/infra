{ pkgs, ... }:
{
  home-manager.users.alina.gtk.iconTheme = {
    package = pkgs.candy-icons;
    name = "Candy";
  };
}
