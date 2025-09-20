{ lib, config, ... }:
{
  system.autoUpgrade = {
    enable = true;
    operation = "boot";
    upgrade = false;
    flake = "git+ssh://git@git.gay/alina/flake.git";
    persistent = true;
    allowReboot = !config.l.profiles.desktop.enable;
    rebootWindow = {
      lower = "01:00";
      upper = "05:00";
    };
  };
}
