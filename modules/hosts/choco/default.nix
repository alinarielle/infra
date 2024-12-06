{config, lib, ...}: with config.l.lib; {
  l.desktop.kde = enable ["config"];
  l.desktop.common.bluetooth.enable = lib.mkForce false;
  l.profiles = enable ["base" "hardened"];
}
