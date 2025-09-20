{ config, lib, ... }:
with config.l.lib;
{
  l.profiles = enable [
    "base"
    "hardened"
  ];
  l.kernel.hardenedLibre.enable = lib.mkForce false;
  l.packages = enable [
    "development"
    "pentesting"
    "chat"
  ];
}
