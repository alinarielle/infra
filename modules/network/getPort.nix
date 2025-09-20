{
  lib,
  cfg,
  opt,
  ...
}:
{
  options.l.network.lib = with lib.types; lib.mkOption { type = attrs; };
  config.l.network.lib.getPort =
    service:
    let
      alphabet = "abcdefghijklmnopqrstuvwxyz";
      l = lib.filter (x: x != "") (lib.splitString "" alphabet);
      num = lib.toIntBase10 (
        builtins.substring 0 19 (
          builtins.replaceStrings l (lib.imap (i: v: builtins.toString i) l) (
            builtins.hashString "sha256" service
          )
        )
      );
    in
    (lib.mod num (65000 - 50000)) + 50000;
}
