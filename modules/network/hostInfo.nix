{opt, cfg, lib, ...}: {
  opt = with lib.types; {
    NATed = lib.mkOption { type = bool; default = true; };
  };
}
