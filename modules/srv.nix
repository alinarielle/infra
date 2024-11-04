{opt, cfg, lib, ...}: {
  opt = with lib.types; lib.mkOption { default = {}; type = (submodule {
    options = {
      tasks = lib.mkOption { default = {}; type = attrs; };
      folders = lib.mkOption { default = {}; type = attrs; };
    };
  })};
  config = {
    l.tasks = mapAttrs (key: val: val.tasks) cfg;
    l.folders = mapAttrs (key: val: val.folders) cfg;
  };
}
