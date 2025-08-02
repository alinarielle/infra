{pkgs, lib, cfg, ...}: {
  opt.pkgs = with lib.types; lib.mkOption { type = attrsOf package; default = null; };
  environment.systemPackages = lib.attrValues cfg.pkgs;
  home-manager.users.alina.xdg = {
    enable = true;
    desktopEntries = lib.mapAttrs (key: val: {
      comment = "This is a launcher wrapper for the script ${key}.";
      name = key;
      exec = "${lib.getExe val}";
      terminal = true;
    }) cfg.pkgs;
  };

}
