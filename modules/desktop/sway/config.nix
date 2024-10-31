{ lib, pkgs, config, ...}: {
  hardware.graphics.enable = true;
  programs.sway.enable = true;
  programs.sway.extraPackages = with pkgs; [
    swaybg
  ];
  l.desktop.common = config.l.lib.enable [
    "audio" "bluetooth" "cursor" "fonts" "home-manager" "hyfetch" "kitty"
    "librewolf" "mako" "printing" "nix-daemon" "theme" "wayland" "zathura"
  ];
  l.packages = config.l.lib.enable ["desktop"];
  home-manager.users.alina = {
    wayland.windowManager.sway = {
      enable = true;
      config = rec {
	terminal = "kitty";
	colors = with config.l.desktop.common.theme.colors; { 
	  focused = {
	    background = "#${white}";
	    border = "#${primary}";
	    childBorder = "#${primary}";
	    indicator = "#${primary}";
	    text = "#${white}";
	  };
	};
        modifier = "Mod4"; # set mod to meta
	bars = []; # set to empty list to disable bar entirely
	menu = "${terminal} ${pkgs.sway-launcher-desktop}";
	keybindings = let
	  brightnessctl = lib.getExe pkgs.brightnessctl;
	  playerctl = lib.getExe pkgs.playerctl;
	in lib.mkOptionDefault {
	  "XF86AudioPlay" = "exec ${playerctl} play-pause";
	  "XF86AudioNext" = "exec ${playerctl} next";
	  "XF86AudioPrev" = "exec ${playerctl} previous";

	  "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%+";
	  "XF86AudioLowerVolume" = " exec wpctl set-volume @DEFAULT_SINK@ 5%-";
	  "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_SINK@ toggle";

	  "XF86MonBrightnessUp" = "exec ${brightnessctl} set +5%";
	  "XF86MonBrightnessDown" = "exec ${brightnessctl} set 5%-";

	  "${modifier}+P" = "exec grimblast copy area";
	  "${modifier}+shift+x" = "exec poweroff";
	  "${modifier}+shift+y" = "exec reboot";

	  "${modifier}+l" = "exec loginctl lock-session";
	};
      };
      extraConfigEarly = ''
	gaps inner 0
	smart_gaps on
	input * {
	  xkb_options compose:ralt
	  xkb_layout us
	  dwt disabled
	  dwtp disabled
	  tap disabled
	  #events enabled
	}
	output eDP-1 scale 1.5
	output * bg ${./wallpaper.png} fill
	for_window [class=".*"] border pixel 2
	for_window [title="sway-launcher-desktop"] floating enable, resize set 500 650
	for_window [title="Please Confirm..." class="Godot"] floating enable
	for_window [title="Create New Project" class="Godot"] floating enable
	''; #TODO translate more into nix and handle wallpapers correctly
    };
  };
}
