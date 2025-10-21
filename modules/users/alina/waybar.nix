{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.alina.packages = with pkgs; [ waybar ];
  home-manager.users.alina = {
    wayland.windowManager.sway.config.startup = [
      {
        command = "${lib.getExe pkgs.waybar}";
        always = false;
      }
    ];
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          modules-left = [
            "sway/workspaces"
            "sway/mode"
            "sway/window"
            "tray"
          ];
          modules-center = [ "cava" ];
          modules-right = [
            "network"
            "wireplumber"
            "cpu"
            "memory"
            "battery"
          ];
          "cava" = {
            "cava_config" = "/home/alina/.config/cava/config";
            "framerate" = 30;
            "autosens" = 0;
            "sensitivity" = 300;
            "bars" = 40;
            "lower_cutoff_freq" = 50;
            "higher_cutoff_freq" = 10000;
            "hide_on_silence" = true;
            #"format_silent" = "quiet";
            "method" = "pipewire";
            "source" = "auto";
            "stereo" = true;
            "reverse" = false;
            "bar_delimiter" = 0;
            "monstercat" = true;
            "waves" = false;
            "noise_reduction" = 0.5;
            "input_delay" = 2;
            "format-icons" = [
              "⣀"
              "⣤"
              "⣶"
              "⣿"
            ];
            "actions" = {
              "on-click-right" = "mode";
            };
          };
          "sway/window" = {
            "format" = "{title}";
            "max-length" = 80;
            "all-outputs" = true;
            "offscreen-css" = true;
            "offscreen-css-text" = "(inactive)";
            "rewrite" = {
              "(.*) - LibreWolf" = " [$1]";
              "(.*) nv" = " [$1]";
              "(.*) - Spotify" = " [$1]";
            };
          };
          mpris = {
            format = "DEFAULT: {player_icon} {dynamic}";
            format-paused = "DEFAULT: {status_icon} <i>{dynamic}</i>";
            player-icons = {
              default = "";
              mpv = "";
              librewolf = " ";
              spotify = " ";
            };
            status-icons = {
              paused = "⏸";
            };
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
            format-icons = [
              " "
              " "
              " "
              " "
              " "
            ];
            states = {
              critical = 10;
              warning = 25;
            };
          };
          wireplumber = {
            format = "{icon} {volume}%";
            format-icons = [
              ""
              " "
              " "
            ];
            on-click = "helvum";
            on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
            max-volume = 150;
            scroll-step = 0.2;
          };
          clock = {
            format = "{:%a %Y-%m-%d %H:%M:%S%z}";
            interval = 1;
          };
          network = {
            format-wifi = "  {ipaddr}/{cidr}";
            format-ethernet = "󱘖 {ipaddr}/{cidr}";
            format-disconnected = "󰈂 {ipaddr}/{cidr}";
            tooltip-format = "Frequency: {frequency}MHz\nStrength:{signaldBm}dBm";
            max-length = 50;
            interval = 5;
          };
          temperature = {
            critical-treshold = 70;
            format = " {temperatureC}°C";
            interval = 1;
            #hwmon-path = "/sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input";
          };
        };
      };
      style = with config.l.users.alina.theme.colors; ''
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
