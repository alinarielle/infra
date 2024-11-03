{opt, cfg, lib, ...}: {
  opt = with lib.types; lib.mkOption { default = {}; type = (submodule {
    options = {
      tasks = lib.mkOption { default = {}; type = attrs; };
    };
  })};
  config = {
    l.tasks.index = mapAttrs (key: val: val.tasks) cfg;
  };
}
