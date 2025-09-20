{
  pkgs,
  lib,
  cfg,
  opt,
  ...
}:
{
  options.l.scripts.pkgs =
    with lib.types;
    lib.mkOption {
      type = attrsOf package;
      default = null;
    };
  config.environment.systemPackages = lib.attrValues cfg.pkgs;
  config.home-manager.users.alina.xdg = {
    enable = true;
    desktopEntries = lib.mapAttrs (key: val: {
      comment = "This is a launcher wrapper for the script ${key}.";
      name = key;
      exec = "${lib.getExe val}";
      terminal = true;
    }) cfg.pkgs;
  };

}
