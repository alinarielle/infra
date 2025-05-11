{pkgs, lib, config, ...}: let
  wallpaper = import ../../../pkgs/wallpaper {
    inherit (config.l.desktop.common.theme) colors;
    inherit pkgs lib;
  }; 
in {
  security.pam.services.hyprlock = {};
  home-manager.users.alina.programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 2;
        ignore_empty_input = true;
        fail_timeout = 1000;
      };
      background = [{
        path = "${wallpaper}/wallpaper.png";
        blur_passes = 2;
        blur_size = 8;
      }];
      input-field = [{
        size = "200, 50";
        position = "0, -80";
      }];
      label = [{
        text = "woof :3";
        font_size = 25;
        halign = "center";
        valign = "center";
      }];
    };
    extraConfig = ''
      
    '';
  };
}
