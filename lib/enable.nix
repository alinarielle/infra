{ lib, ... }:
{
  options.l.lib = lib.mkOption {
    type = lib.types.attrs;
    default = { };
  };
  config.l.lib.enable = (
    list:
    lib.genAttrs list (name: {
      enable = true;
    })
  );
}
