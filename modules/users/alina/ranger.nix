{ pkgs, ... }:
{
  users.users.alina.packages = [ pkgs.python312Packages.pillow ];
  home-manager.users.alina.programs.ranger.enable = true;
  home-manager.users.alina.programs.ranger.settings = {
    confirm_on_delete = "never";
    preview_images = true;
    preview_images_method = "kitty";
  };
}
