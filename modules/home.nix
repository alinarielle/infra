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
          json = attrs;
          ini = attrs;
          yaml = attrs;
        };
      });
    };

  config.home-manager.users.alina.xdg.configFile =
    let
    in
    lib.mapAttrs (
      key: val:
      let
        format =
          if val.json != null then
            "json"
          else if val.ini != null then
            "ini"
          else if val.yaml != null then
            "yaml"
          else
            null;
      in
      (pkgs.formats.${format} { }).generate val.${format}
    ) config.h;
}
