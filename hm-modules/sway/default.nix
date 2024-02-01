{ lib, ...}:
{
    wayland.windowManager.sway = {
	enable = true;
	config = rec {
	    terminal = "kitty";
            colors.focused = {
		background = "#285577";
		border = "#00b3ff";
		childBorder = "#00b3ff";
		indicator = "#2e9ef4";
		text = "#ffffff";
	    };
	    modifier = "Mod4"; # set mod to meta
	    bars = []; # set to empty list to disable bar entirely
	    menu = "kitty sway-launcher-desktop";
	    keybindings = lib.mkOptionDefault {
		"${modifier}+P" = "exec grimshot copy area";
		"${modifier}+shift+x" = "poweroff";
		"${modifier}+shift+y" = "reboot";
	    };
	};
	extraConfigEarly = ''
	    blur on
	    blur_xray on
	    blur_passes 2
	    blur_radius 5
	    gaps inner 0
	    smart_gaps on
	    input * {
	    	xkb_options compose:ralt
		xkb_layout us
		}
	    output eDP-1 scale 1.5
	    output * bg #201622 solid_color
	    for_window [class=".*"] border pixel 2
	    exec --no-startup-id kitty --hold sh -c "hyfetch; zsh"
	    for_window [title="sway-launcher-desktop"] floating enable, resize set 500 650
	'';
    };
}
