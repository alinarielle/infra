{ pkgs, config, ... }:
with config.l.lib;
{
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
  ];

  l.desktop.common = enable [
    "audio"
    "bluetooth"
    "cursor"
    "fonts"
    "home-manager"
    "hyfetch"
    "librewolf"
    "printing"
    "nix-daemon"
    "theme"
    "wayland"
    "kitty"
  ];
  l.packages = enable [
    "desktop"
  ];
}
