{ lib, pkgs, config, ...}:

{

    imports = [
	./waybar.nix
	./swaylock.nix
	../librewolf.nix
	../cursor.nix
	../theme.nix
    ];

users.users.alina.packages = with pkgs; [
    qt5.qtwayland
    waypipe
    wl-clipboard
    wlprop
    wev
    wf-recorder
    slurp
    sway-launcher-desktop
];

hardware.opengl.enable = true;
programs.sway.enable = true;

environment.sessionVariables = {
    SDL_VIDEODRIVER = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    NIXOS_OZONE_WL = "1";
};

home-manager.users.alina = {
    wayland.windowManager.sway = {
	enable = true;
	config = rec {
	    terminal = "kitty";
            colors = { 
	    	focused = {
		    background = "#${config.colorScheme.palette.base06}"; # ++++
		    border = "#${config.colorScheme.palette.base0D}"; # blue
		    childBorder = "#${config.colorScheme.palette.base0D}"; # blue
		    indicator = "#${config.colorScheme.palette.base0D}"; # blue
		    text = "#${config.colorScheme.palette.base06}"; # ++++
	        };
	    };
	    modifier = "Mod4"; # set mod to meta
	    bars = []; # set to empty list to disable bar entirely
	    menu = "${terminal} sway-launcher-desktop";
	    keybindings = lib.mkOptionDefault {
	    	"XF86AudioPlay" = "exec playerctl play-pause";
		"XF86AudioNext" = "exec playerctl next";
		"XF86AudioPrev" = "exec playerctl previous";

		"XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%+";
		"XF86AudioLowerVolume" = " exec wpctl set-volume @DEFAULT_SINK@ 5%-";
		"XF86AudioMute" = "exec wpctl set-mute @DEFAULT_SINK@ toggle";

		"XF86MonBrightnessUp" = "exec brightnessctl set +5%";
		"XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

		"${modifier}+P" = "exec grimshot copy area";
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
		tap enabled
		events enabled
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
