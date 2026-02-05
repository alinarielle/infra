{ config, lib, ... }:
with config.l.lib;
{
  l.profiles = enable [
    "base"
    # "hardened"
  ];
}
