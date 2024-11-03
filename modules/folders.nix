{opt, cfg, lib, ...}: {
  opt = with lib.types; lib.mkOption { default = {}; type = (submodule {
    options = {
      path = lib.mkOption { type = path; };
      user = lib.mkOption { type = str; default = "root"; };
      group = lib.mkOption { type = str; default = "root"; };
      mode = lib.mkOption { type = str; default = "770"; };
      persist = lib.mkOption { type = bool; default = true; };
    };
  });};
  config = lib.mkMerge [(lib.mkIf l.filesystem.impermanence.enable {
    l.filesystem.impermanence.keep = lib.mapAttrsToList (key: val: val.path ) cfg;
  })] ++ (lib.mapAttrsToList (key: val: {
    systemd.tmpfiles.settings."${val.key}-state".${val.path}.d = {
      inherit (val) group user mode;
      age = "-";
      type = "d";
    };
  }) cfg;
}
