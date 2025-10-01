{
  config,
  lib,
  pkgs,
  ...
}:
{
  home-manager.users.alina.programs.kitty = {
    enable = true;
    settings = with config.l.users.alina.theme.colors; rec {
      shell = "${lib.getExe pkgs.nushell}";

      font_size = "11.0";
      font_family = "JetBrainsMono Nerd Font Propo";
      bold_font = font_family + " Bold";
      italic_font = font_family + " Italic";
      bold_italic_font = font_family + " Bold Italic";

      cursor = "${cyan}";
      cursor_shape = "beam";
      cursor_blink_interval = "1.0"; # in seconds

      url_style = "double";

      enable_audio_bell = "no";
      visual_bell_duration = "0.0";
      window_alert_on_bell = "yes";
      bell_on_tab = "yes";

      window_padding_width = "0";

      confirm_os_window_close = "0";

      tab_bar_edge = "bottom";
      tab_bar_margin_width = "3.0";
      tab_bar_margin_height = "5.0 3.0";
      tab_bar_style = "powerline";
      tab_bar_min_tabs = "2";
      tab_separator = "  ";
      tab_powerline_style = "angled";
      tab_activity_symbol = "⦿";

      background_opacity = "0.60";

      foreground = "${white}";
      background = "${black}";
      color0 = "${black}";
      color1 = "${magenta}";
      color2 = "${green}";
      color3 = "${yellow}";
      color4 = "${blue}";
      color5 = "${pink}";
      color6 = "${cyan}";
      color7 = "${white}";
      color8 = color0;
      color9 = color1;
      color10 = color2;
      color11 = color3;
      color12 = color4;
      color13 = color5;
      color14 = color6;
      color15 = color7;
    };
  };
}
