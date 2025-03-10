{config, lib, ...}: with config.l.lib; {
  l.profiles = enable ["base" "hardened"];
  l.desktop.sway = enable ["config" "swaylock" "waybar"];
  l.kernel.hardenedLibre.enable = lib.mkForce false;
  l.packages = enable [
    "development" "pentesting" "chat"
  ];
  l.network = enable ["mullvad"];
}
