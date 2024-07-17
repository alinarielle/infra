{config, lib, ...}: {
    home-manager.users.alina.programs.kitty = lib.mkIf config.l.desktop.any.enable {
	enable = true;
	shellIntegration.enableZshIntegration = if config.programs.zsh.enable then true else false;
	settings =
	let
	    color = config.colorScheme.palette;
	in
	rec {
	    font_family = "JetBrainsMono Nerd Font Propo";
	    bold_font = font_family + " Bold";
	    italic_font = font_family + " Italic";
	    bold_italic_font = font_family + " Bold Italic";

	    cursor = "#${color.cyan}";
	    cursor_shape = "beam";
	    cursor_blink_interval = "1.0"; # in seconds

	    url_style = "double";

	    enable_audio_bell = "no";
	    visual_bell_duration = "0.2";
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
	    
	    background_opacity = "0.8";

	    foreground = "#${color.white}";
	    background = "#${color.dark}";
	    color0 = "#${color.dark}";
	    color1 = "#${color.magenta}";
	    color2 = "#${color.green}";
	    color3 = "#${color.yellow}";
	    color4 = "#${color.blue}";
	    color5 = "#${color.pink}";
	    color6 = "#${color.cyan}";
	    color7 = "#${color.white}";
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
