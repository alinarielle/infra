{ lib, pkgs, ...}:

{

    imports = [
	./waybar.nix
	./swaylock.nix
	../librewolf.nix
	../cursor.nix
    ];

users.users.alina.packages = with pkgs; [
    qt5.qtwayland
    waypipe
    wl-clipboard
    wlprop
    wev
    wf-recorder
    slurp
];

hardware.opengl.enable = true;

xdg.portal.enable = true;
xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];

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
            colors.focused = {
		background = "#285577";
		border = "#00b3ff";
		childBorder = "#00b3ff";
		indicator = "#2e9ef4";
		text = "#ffffff";
	    };
	    modifier = "Mod4"; # set mod to meta
	    bars = []; # set to empty list to disable bar entirely
	    menu = "kitty ${pkgs.sway-launcher-desktop}";
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
