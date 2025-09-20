{ config, ... }:
{
  home-manager.users.alina.services.mako = with config.l.desktop.common.theme.colors; {
    enable = true;
    settings = {
      backgroundColor = black;
      borderColor = primary;

      borderRadius = 5;
      borderSize = 2;

      height = 100;

      defaultTimeout = 5000;

      font = "JetBrainsMono Nerd Font 10";
    };
  };
}
