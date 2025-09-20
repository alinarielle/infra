{ config, ... }:
with config.l.lib;
{
  l.packages = enable [ "noDefaultPackages" ];
  l.filesystem = enable [
    "blacklist"
    "sysctl"
  ];
  l.network = enable [ "sysctl" ];
}
