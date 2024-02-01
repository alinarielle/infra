{
    programs.waybar = {
	enable = true;
	systemd.enable = true;
	settings = {
	    mainBar = {
		layer = "top";
		position = "top";
		height = 25;
		output = "eDP-1";
		modules-left = [ "sway/workspaces" "sway/mode" "sway/scratchpad"];
		modules-center = ["sway/window"];
		modules-right = ["tray" "disk" "pulseaudio" "network" "cpu"
		"memory" "temperature" "backlight" "battery" "clock"];
	
		"sway/scratchpad" = {
		    format  = "{icon} {count}";
		    show-empty = "false";
		    format-icons = '' ["", ""] '';
		    tooltip = "true";
		    tooltip-format = ''"{app}: {title}"'';
		};
		tray = {
		    #icon-size = "21";
		    spacing = "0";
		};
		"sway/workspaces" = {
		    disable-scroll = true;
		    all-outputs = true;
		};
		battery = {
			format = "{icon} {capacity}%";
			format-time = "{H}h {M}min";
			format-icons = '' ["", "", "", "", ""] '';
			max-length = "25";
			states = ''
			    "warning": 30,
			    "critical": 15
			'';
		};
		clock = {
		    format = "{:%Y/%m/%d %H:%M}";
		};
	    };
	};
    };
}
