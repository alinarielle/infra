{opt, cfg, lib, config, ...}: {
  opt = with lib.types; lib.mkOption { default = []; type = attrsOf (submodule {
    options = {
      user = lib.mkOption { type = str; default = "root"; };
      group = lib.mkOption { type = str; default = "root"; };
      mode = lib.mkOption { type = str; default = "750"; };
      persist = lib.mkOption { type = bool; default = true; };
    };
  });};
  systemd.tmpfiles.settings.folders = lib.mapAttrs (k: v: { d = {
    inherit (v) user group mode;
  }; }) cfg;
  environment.persistence."/persist".directories = lib.mapAttrsToList (k: v: 
    lib.mkIf v.persist k
  ) cfg;
}
