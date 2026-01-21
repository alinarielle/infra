{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  widgetFile = pkgs.writeText "widget.qml" ''
    import QtQuick
    import QtQuick.Layouts
    import qs.Commons
    import qs.Services

    Rectangle {
      id: root

      // Provided by Bar.qml via NWidgetLoader
      property var screen
      property real scaling: 1.0
      property string widgetId: ""
      property string section: ""
      property int sectionWidgetIndex: -1
      property int sectionWidgetsCount: 0

      // Access your metadata and per-instance settings
      property var widgetMetadata: BarWidgetRegistry.widgetMetadata[widgetId]
      property var widgetSettings: {
        if (section && sectionWidgetIndex >= 0) {
          var widgets = Settings.data.bar.widgets[section]
          if (widgets && sectionWidgetIndex < widgets.length) {
            return widgets[sectionWidgetIndex]
          }
        }
        return {}
      }

      implicitHeight: Math.round(Style.capsuleHeight * scaling)
      implicitWidth: Math.round(120 * scaling)
      radius: Math.round(Style.radiusS * scaling)
      color: Color.mSurfaceVariant
      border.width: Math.max(1, Style.borderS * scaling)
      border.color: Color.mOutline

      RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: Style.marginXS * scaling
        spacing: Style.marginXS * scaling

        NText {
          text: widgetSettings.text !== undefined ? widgetSettings.text : (widgetMetadata?.text || "Hello")
          font.pointSize: Style.fontSizeXS * scaling
          font.weight: Style.fontWeightBold
          color: Color.mPrimary
          Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        }
      }
    }
  '';
in
{
  imports = [
    inputs.noctalia.nixosModules.default
  ];
  services.noctalia-shell.enable = true;
  home-manager.users.alina = {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      colors = {
        mError = "#e9899d";
        mOnError = "#1e1418";
        mOnPrimary = "#1a151f";
        mOnSecondary = "#f3edf7";
        mOnSurface = "#e9e4f0";
        mOnSurfaceVariant = "#a79ab0";
        mOnTertiary = "#20161f";
        mOutline = "#3e364e";
        mPrimary = "#c7a1d8";
        mSecondary = "#a984c4";
        mShadow = "#120f18";
        mSurface = "#1c1822";
        mSurfaceVariant = "#262130";
        mTertiary = "#e0b7c9";
      };
      settings = {
        appLauncher = {
          backgroundOpacity = 1;
          enableClipboardHistory = true;
          pinnedExecs = [ ];
          position = "center";
          sortByMostUsed = true;
          terminalCommand = "kitty -e nu -c ";
          useApp2Unit = false;
        };
        audio = {
          cavaFrameRate = 30;
          mprisBlacklist = [ ];
          preferredPlayer = "spotify";
          visualizerType = "linear";
          volumeOverdrive = false;
          volumeStep = 1;
        };
        bar = {
          backgroundOpacity = 1;
          density = "comfortable";
          floating = false;
          marginHorizontal = 0.25;
          marginVertical = 0.25;
          monitors = [ ];
          position = "bottom";
          showCapsule = true;
          widgets = {
            center = [
              {
                hideUnoccupied = true;
                id = "Workspace";
                labelMode = "index";
              }
              {
                icon = "device-heart-monitor";
                id = "CustomButton";
                leftClickExec = lib.getExe pkgs.writeShellScriptBin "rotate" ''
                  nu -c '
                                   let state = swaymsg -t get_tree | jq . | from json | get nodes | where name =~ "eDP" | first | get transform;
                                   let result = match $state {
                                     "normal" => { sway output eDP-1 transform 270 }
                                     _ => { sway output eDP-1 transform 0 }
                                   }
                                   $result | echo "[ { "success": true } ]" | from json | get success | first
                                 ' '';
                middleClickExec = "";
                rightClickExec = "";
                textCommand = "";
                textIntervalMs = 3000;
              }
            ];
            left = [
              {
                hideMode = "hidden";
                id = "MediaMini";
                maxWidth = 700;
                scrollingMode = "hover";
                showAlbumArt = true;
                showVisualizer = true;
                useFixedWidth = false;
                visualizerType = "linear";
              }
              {
                colorizeIcons = false;
                hideMode = "hidden";
                id = "ActiveWindow";
                maxWidth = 350;
                scrollingMode = "hover";
                showIcon = true;
                useFixedWidth = false;
              }
            ];
            right = [
              {
                customFont = "";
                formatHorizontal = "dddd, HH:mm t";
                formatVertical = "HH mm - dd MM";
                id = "Clock";
                useCustomFont = false;
                usePrimaryColor = true;
              }
              { id = "WallpaperSelector"; }
              {
                displayMode = "onhover";
                id = "Bluetooth";
              }
              {
                displayMode = "alwaysShow";
                id = "Microphone";
              }
              {
                displayMode = "alwaysShow";
                id = "Volume";
              }
              {
                icon = "arrow-capsule";
                id = "CustomButton";
                leftClickExec = "nu -c 'job spawn {cd ~/infra; nix run}'";
                middleClickExec = "";
                rightClickExec = "";
                textCommand = "";
                textIntervalMs = 3000;
              }
              {
                hideWhenZero = true;
                id = "NotificationHistory";
                showUnreadBadge = true;
              }
              {
                icon = "arrow-guide-filled";
                id = "CustomButton";
                leftClickExec = "helvum";
                middleClickExec = "";
                rightClickExec = "";
                textCommand = "";
                textIntervalMs = 3000;
              }
              {
                customIconPath = "";
                icon = "";
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
          };
        };
        battery = {
          chargingMode = 0;
        };
        brightness = {
          brightnessStep = 10;
        };
        colorSchemes = {
          darkMode = true;
          generateTemplatesForPredefined = true;
          manualSunrise = "06:30";
          manualSunset = "18:30";
          matugenSchemeType = "scheme-fruit-salad";
          predefinedScheme = "Noctalia (legacy)";
          schedulingMode = "off";
          useWallpaperColors = false;
        };
        controlCenter = {
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
          ];
          position = "bottom_right";
          shortcuts = {
            left = [
              { id = "WiFi"; }
              { id = "Bluetooth"; }
              { id = "ScreenRecorder"; }
              { id = "WallpaperSelector"; }
            ];
            right = [
              { id = "Notifications"; }
              { id = "PowerProfile"; }
              { id = "KeepAwake"; }
              { id = "NightLight"; }
            ];
          };
        };
        # dock = {
        #   backgroundOpacity = 0.56;
        #   colorizeIcons = false;
        #   displayMode = "auto_hide";
        #   floatingRatio = 0;
        #   monitors = [ ];
        #   onlySameOutput = false;
        #   pinnedApps = [ ];
        #   size = 1.02;
        # };
        general = {
          animationDisabled = false;
          animationSpeed = 1.00;
          avatarImage = ./avi.jpg;
          compactLockScreen = false;
          dimDesktop = true;
          forceBlackScreenCorners = false;
          language = "";
          lockOnSuspend = true;
          radiusRatio = 0.58;
          scaleRatio = 1;
          screenRadiusRatio = 1;
          showScreenCorners = false;
        };
        hooks = {
          darkModeChange = "";
          enabled = true;
          wallpaperChange = "";
        };
        location = {
          name = "Berlin";
          showCalendarEvents = true;
          showWeekNumberInCalendar = true;
          use12hourFormat = false;
          useFahrenheit = false;
          weatherEnabled = true;
        };
        network = {
          wifiEnabled = true;
        };
        nightLight = {
          autoSchedule = false;
          dayTemp = "6500";
          enabled = true;
          forced = false;
          manualSunrise = "06:30";
          manualSunset = "18:30";
          nightTemp = "4000";
        };
        notifications = {
          criticalUrgencyDuration = 15;
          doNotDisturb = true;
          location = "top_left";
          lowUrgencyDuration = 2;
          monitors = [ ];
          normalUrgencyDuration = 3;
          overlayLayer = true;
          respectExpireTimeout = false;
        };
        osd = {
          autoHideMs = 3000;
          enabled = true;
          location = "top_right";
          monitors = [ ];
          overlayLayer = true;
        };
        screenRecorder = {
          audioCodec = "aac";
          audioSource = "both";
          colorRange = "limited";
          directory = "/home/alina/blob";
          frameRate = 60;
          quality = "very_high";
          showCursor = true;
          videoCodec = "h264";
          videoSource = "portal";
        };
        settingsVersion = 16;
        setupCompleted = true;
        templates = {
          discord = false;
          discord_armcord = false;
          discord_dorion = false;
          discord_equibop = false;
          discord_lightcord = false;
          discord_vesktop = false;
          discord_webcord = false;
          enableUserTemplates = true;
          foot = false;
          fuzzel = false;
          ghostty = false;
          gtk = true;
          kcolorscheme = true;
          kitty = true;
          pywalfox = false;
          qt = true;
          vicinae = false;
        };
        ui = {
          fontDefault = "JetBrainsMonoNL Nerd Font";
          fontDefaultScale = 1.1;
          fontFixed = "DejaVu Sans Mono";
          fontFixedScale = 1;
          panelsOverlayLayer = true;
          tooltipsEnabled = true;
        };
        wallpaper = {
          defaultWallpaper = (
            import ../../../pkgs/wallpaper {
              inherit (config.l.users.alina.theme) colors;
              inherit lib pkgs;
            }
          );
          directory = "/home/alina/blob/wallpapers";
          enableMultiMonitorDirectories = false;
          enabled = true;
          fillColor = "#000000";
          fillMode = "stretch";
          monitors = [
            {
              directory = "/home/alina/blob/wallpapers";
              name = "eDP-1";
              wallpaper = "/home/alina/blob/wallpapers/panes.jpg";
            }
          ];
          randomEnabled = true;
          randomIntervalSec = 1800;
          setWallpaperOnAllMonitors = true;
          transitionDuration = 1500;
          transitionEdgeSmoothness = 0.25;
          transitionType = "random";
        };
      };
    };
  };
}
