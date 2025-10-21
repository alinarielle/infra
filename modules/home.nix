{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.h =
    with lib.types;
    lib.mkOption {
      default = { };
      type = attrsOf (submodule {
        options = {
          json = lib.mkOption {
            type = attrs;
          };
          ini = lib.mkOption {
            type = attrs;
          };
          yaml = lib.mkOption {
            type = attrs;
          };
        };
      });
    };

  config.home-manager.users.alina.xdg.configFile = lib.mapAttrs (
    key: val:
    let
      format =
        if val ? json then
          "json"
        else if val ? ini then
          "ini"
        else if val ? yaml then
          "yaml"
        else
          null;
    in
    (pkgs.formats.${format} { }).generate val.${format}
  ) config.h;
}
