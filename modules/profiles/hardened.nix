{ config, ... }:
with config.l.lib;
{
  l.packages = enable [ "noDefaultPackages" ];
  l.storage.filesystem = enable [
    "blacklist"
    "sysctl"
  ];
  l.network = enable [ "sysctl" ];
}
