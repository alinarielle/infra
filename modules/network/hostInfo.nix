{opt, cfg, lib, ...}: {
  opt = {
    NATed = lib.mkOption { type = bool; default = true; };
  };
}
