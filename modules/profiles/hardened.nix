{ config, ... }:
with config.l.lib;
{
  l.storage.filesystem = enable [
    "blacklist"
    "sysctl"
  ];
  l.network = enable [ "sysctl" ];
}
