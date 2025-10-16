{
  opt,
  cfg,
  lib,
  name,
  nodes,
  ...
}:
{
  opt = with lib.types; {
    endpoints = lib.mkOption {
      default = { };
      type = listOf (submodule {
        options = {
          url = lib.mkOption { type = str; };
          observerService = lib.mkOption {
            type = enum [
              "prometheus"
              "victoriametrics"
              "zabbix"
            ];
            default = "victoriametrics";
          };
          observerHost = lib.mkOption {
            type = nullOr enum (lib.filter (x: x != name) (lib.attrNames nodes));
            default = "eris";
          };
        };
      });
    };
  };
  config =
    let
      myEndpoints = lib.foldl' (
        acc: endpoint: acc ++ lib.optionals (endpoint.observerHost == name) endpoint
      ) [ ] (lib.attrValues nodes);
    in
    {
      services.victoriametrics = {
        enable = true;
        prometheusConfig = { };
      };
    };
}
