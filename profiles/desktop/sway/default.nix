{ lib, pkgs, config, ...}: {
    imports = [
	./waybar.nix
	./swaylock.nix
	../theme.nix
	../mako.nix
	../wayland.nix
    ];

    hardware.opengl.enable = true;
    programs.sway.enable = true;

    programs.sway.extraPackages = with pkgs; [
        swaybg
	kitty
    ];

home-manager.users.alina = {
    wayland.windowManager.sway = {
	enable = true;
	config = rec {
	    terminal = "kitty";
            colors = 
	    let 
	        color = config.colorScheme.palette;
	    in
	    { 
	    	focused = {
		    background = "#${color.white}";
		    border = "#${color.blue}";
		    childBorder = "#${color.blue}";
		    indicator = "#${color.blue}";
		    text = "#${color.white}";
	        };
	    };
	    modifier = "Mod4"; # set mod to meta
	    bars = []; # set to empty list to disable bar entirely
	    menu = "${terminal} sway-launcher-desktop";
	    keybindings =
	    let
	        brightnessctl = lib.getExe pkgs.brightnessctl;
		playerctl = lib.getExe pkgs.playerctl;
	    in
	    lib.mkOptionDefault {
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
		#dwt disabled
		#dwtp disabled
		tap enabled
		#events enabled
	    }
	    output eDP-1 scale 1.5
	    output * bg wallpaper.png fill
	    for_window [class=".*"] border pixel 2
	    exec --no-startup-id kitty --hold sh -c "hyfetch; zsh"
	    for_window [title="sway-launcher-desktop"] floating enable, resize set 500 650
	    for_window [title="Please Confirm..." class="Godot"] floating enable
	    for_window [title="Create New Project" class="Godot"] floating enable
	'';
    };
};
}
