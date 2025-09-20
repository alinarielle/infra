{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.home-assistant = {
    enable = true;
    configWritable = false;
    lovelaceConfigWritable = false;
    lovelaceConfig = {
      title = "alina's home assistant";
      views = [ { } ];
    };
    extraPackages = with pkgs; [
      python312Packages.psycopg2
    ];
    extraComponents = [
      "caldav"
      "calendar"
      "alarm_control_panel"
      "manual_alarm_control_panel"
      "template_alarm_control_panel"
      "date"
      "alert"
      "automation"
      "flux"
      "input_text"
      "input_datetime"
      "input_button"
      "input_boolean"
      "blueprint"
      "counter"
      "sun"
      "device_automation"
      "keyboard"
      "proximity"
      "tags"
      "timer"
      "wheather"
      "mqtt"
      "template"
      "zigbee_home_automation"
      "camera"
      "bluetooth"
      "auth"
      "backup"
      "climate"
      "command_line"
      "configuration"
      "my"
      "mullvad_vpn"
      "mpd"
      "coinbase"
      "configurator"
      "cover"
      "custom_panel"
      "assist_pipeline"
      "mobile_app"
      "config"
      "history"
      "homeassistant_alerts"
      "image_upload"
      "logbook"
      "ssdp"
      "usb"
      "webhook"
      "zeroconf"
      "device_tracker"
      "dns_ip"
      "gtfs"
      "haveibeenpwned"
      "skyconnect"
      "jellyfin"
      "matrix"
      "minecraft_server"
      "moon"
      "network"
      "openexchangerates"
      "openai_conversation"
      "openweathermap"
      "plant"
      "snmp"
      "scenes"
      "schedule"
      "scripts"
      "shodan"
      "shopping_list"
      "simplepush"
      "smtp"
      "qbittorrent"
      "radarr"
      "sonarr"
      "spotify"
      "statistics"
      "switch"
    ];
  };
}
#TODO track moon phases, show moon at night according to its phase
#connect cloudsky LEDs and robots to HA and script them
#show gommehd stats, music controls with mpd, show mullvad connection
#monero price chart, button/detection method for when i'm home
#turn off lights when i'm going to bed, turn on lights and alarm in the morning
#keep sound system connected for alarm and instantanous music play
#program cool cloudlight patterns
