{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  wallpaper = (
    import ../../../pkgs/wallpaper {
      inherit (config.l.users.alina.theme) colors;
      inherit lib pkgs;
    }
  );
in
{
  hardware.graphics.enable = true;
  programs.sway.enable = true;
  programs.sway.package = pkgs.swayfx;
  programs.sway.extraPackages =
    with pkgs;
    let
      flameshot = pkgs.flameshot.override {
        enableWlrSupport = true;
        enableMonochromeIcon = false;
      };
    in
    [
      swaybg
      swayfx
      flameshot
      grim
      slurp
    ];
  home-manager.users.alina = {
    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "kitty.desktop" ];
    };
    wayland.windowManager.sway = with config.l.users.alina.theme.colors; {
      enable = true;
      package = pkgs.swayfx;
      checkConfig = false;
      config = rec {
        colors = {
          focused = {
            background = white;
            border = primary;
            childBorder = primary;
            indicator = primary;
            text = white;
          };
        };
        terminal = lib.getExe config.home-manager.users.alina.xdg.terminal-exec.package;
        modifier = "Mod4"; # set mod to meta
        bars = [ ]; # set to empty list to disable bar entirely
        menu = "kitty --grab-keyboard --start-as=hidden --class=launcher noctalia-shell ipc call launcher toggle";
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

            "${modifier}+P" = "exec flameshot gui";
            "${modifier}+shift+x" = "exec poweroff";
            "${modifier}+shift+y" = "exec reboot";

            "${modifier}+l" = "exec loginctl lock-session";
          };
      };
      extraConfigEarly = ''
        	gaps inner 10
        	smart_gaps off
        	input * {
        	  xkb_options compose:ralt,caps:swapescape
        	  xkb_layout us
        	  dwt disabled
        	  dwtp disabled
        	  tap disabled
        	  #events enabled
        	}
          output eDP-1 scale 1.5
        	output HDMI-A-1 pos 1920 0 res 1920x1080 transform 270
        	for_window [class=".*"] border pixel 2
        	blur enable
        	blur_passes 3
        	blur_radius 2
        	blur_noise 0.15
        	blur_brightness 1.0
        	blur_contrast 1
        	blur_saturation 1

        	corner_radius 10

        	shadows disable

        	layer_effects "noctalia-shell" corner_radius 0

        	default_dim_inactive 0.0

          for_window [app_id="widget1x1"] border pixel 3, floating enable, resize set 500 500
          for_window [app_id="dmenu"] floating enable, resize set 1200 800

          exec noctalia-shell
          exec noctalia-shell ipc call launcher toggle
          exec nu -c "job spawn {signal-desktop}; job spawn {librewolf}; job spawn {syncthing}; job spawn {flameshot}; job spawn {kitty --class dmenu -d ~/infra/ --detach --session --hold --listen-on=unix:@dmenu --override allow_remote_control=socket-only --grab-keyboard --start-as=fullscreen -T dmenu zellij}"
      '';
    };
  };
}
