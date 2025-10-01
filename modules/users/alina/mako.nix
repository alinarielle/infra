{ config, ... }:
{
  home-manager.users.alina.services.mako = with config.l.users.alina.theme.colors; {
    enable = true;
    settings = {
      "actionable=true" = {
        anchor = "top-left";
      };
      actions = true;
      anchor = "top-right";
      border-radius = 0;
      default-timeout = 0;
      height = 100;
      icons = true;
      ignore-timeout = false;
      layer = "top";
      margin = 10;
      markup = true;
      width = 300;
      backgroundColor = black;
      border-color = primary;
      font = "JetBrainsMono Nerd Font 10";
    };
  };
}
