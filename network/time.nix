{lib, config, ...}: lib.mkLocalModule ./. "default timezone" {
    time.timeZone = lib.mkDefault "Europe/Berlin";
}
