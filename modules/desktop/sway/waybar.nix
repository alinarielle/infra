{ config, lib, pkgs, ... }: {
  users.users.alina.packages = with pkgs; [ waybar ];
  home-manager.users.alina = {
    wayland.windowManager.sway.config.startup = [{
      command = "${lib.getExe pkgs.waybar}";
      always = false;
    }];
      programs.waybar = {
        enable = true;
	settings = {
	  mainBar = {
	    layer = "top";
	    position = "bottom";
	    modules-left = [
	      "sway/workspaces"
	      "sway/mode"
	      "tray"
	    ];
	    modules-right = [
	      "network"
	      "temperature"
	      "cpu"
	      "memory"
	      "battery"
	      "clock"
	    ];
      "custom/dog" = {
        format = "{icon}";
        format-icons = {
          dog = 
        };
      };
	    "sway/window" = {
	      format = "{title}";
	    };
	    cpu = {
	      format = "  {usage}%";
	    };
	    memory = {
	      format = "  {percentage}%";
	      states = {
          warning = 15;
          critical = 75;
	      };
	    };
	    battery = {
	      format = "{icon} {capacity}%";
	      format-icons = [ " " " " " " " " " " ];
	      states = {
          critical = 10;
          warning = 25;
	      };
	    };
	    pulseaudio = {
	      format = "{icon} {volume}%";
	      format-icons = [ " " " " ];
	      format-muted = " muted";
	    };
	    clock = {
	      format = "{:%a %Y-%m-%d %H:%M:%S%z}";
	      interval = 1;
	    };
	    network = {
	      format-wifi = "  {essid} ({signalStrength}%)";
	      format-ethernet = "󱘖 online";
	      format-disconnected = "󰈂 offline";
	      tooltip-format = "IPv4: {ipaddr}/{cidr}\nFrequency: {frequency}MHz\nStrength:{signaldBm}dBm";
	      max-length = 50;
	      interval = 5;
	    };
	    temperature = {
	      critical-treshold = 70;
	      format = " {temperatureC}°C";
	      interval = 1;
	      hwmon-path = "/sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input";
	    };
	  };
	};
	style = with config.l.desktop.common.theme.colors;''
* {
border: none;
border-radius: 0;
font-family: "JetBrainsMono Nerd Font", sans-serif;
font-size: 9pt;
}

window {
    background: ${black};
    color: ${white};
}
#workspaces {
    padding-right: 15px;
}

#workspaces button {
    transition: none;
    padding: 0 5px;
    background: rgba(255, 255, 255, .2);
    color: ${white};
}

#workspaces button.icon label {
    font-size: 10px;
}

#workspaces button.focused {
    color: ${black};
    background: ${white};
}

/* :sparkles: maybe needs to be changed to button, when waybar breaks */
window>*>*>*>label {
    margin: 0 7px;
    padding: 5px;
    background-color: ${black};
    color: ${white};
}

#tray {
    margin-left: 10px;
}

#pulseaudio.muted {
    color: ${red}
}
#temperature.critical {
    background: ${red};
    color: ${white};
}
#battery.critical {
    background: ${red};
    color: ${white};
}
#battery.warning {
    background: ${orange};
    color: ${black};
}
#battery.charging {
    background: ${green};
    color: ${black}
}
	'';
    };
  };
  programs.sway.extraPackages = with pkgs; [
    waybar
  ];
}
