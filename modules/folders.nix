{opt, cfg, lib, config, ...}: {
  opt = with lib.types; lib.mkOption { default = {}; type = (submodule {
    options = {
      path = lib.mkOption { type = path; };
      user = lib.mkOption { type = str; default = "root"; };
      group = lib.mkOption { type = str; default = "root"; };
      perms = lib.mkOption { type = str; default = "750"; };
      persist = lib.mkOption { type = bool; default = true; };
    };
  });};
  config = {
    systemd.tmpfiles.settings = lib.mapAttrs (key: val: { ${val.path}.d = {	
      inherit (val) group user mode;
      age = "-";
      type = "d";
    };}) cfg;
  } // (lib.mkIf config.l.filesystem.impermanence.enable {
    l.filesystem.impermanence.keep = lib.mapAttrsToList (key: val: val.path) cfg;
  });
}
