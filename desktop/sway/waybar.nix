{ config, lib, pkgs, ... }:
let
  cfg = config.services.waybar;
  styles = ./waybar-style.css;
  configFile = pkgs.writeText "waybar-config.json" (builtins.toJSON cfg.config);
in config.l.lib.mkLocalModule ./waybar.nix "leonas waybar config" {
  users.users.alina.packages = with pkgs; [ waybar ];
  home-manager.users.alina = {
    xdg.configFile."waybar/config".source = ./waybar-config.json;
    xdg.configFile."waybar/style.css".source = ./waybar-style.css;
    wayland.windowManager.sway.config.startup = [{
      command = "${lib.getExe pkgs.waybar}";
      always = false;
    }];
  };
  programs.sway.extraPackages = with pkgs; [
    waybar
  ];
}
