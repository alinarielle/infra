{lib, config, ...}: config.l.lib.mkLocalModule ./time.nix "default timezone" {
    time.timeZone = lib.mkDefault "Europe/Berlin";
}
