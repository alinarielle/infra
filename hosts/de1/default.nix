{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with config.l.lib;
{
  l.profiles = enable [
    "shell"
    "cloud.hetzner"
  ];
  system.stateVersion = "26.05";
  deployment.targetHost = "de1.net.alina.dog";
}
