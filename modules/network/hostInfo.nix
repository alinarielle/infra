{
  opt,
  cfg,
  lib,
  ...
}:
{
  opt = with lib.types; {
    NATed = lib.mkOption {
      type = bool;
      default = true;
    };
    wanIPv4 = lib.mkOption { type = str; };
  };
}
