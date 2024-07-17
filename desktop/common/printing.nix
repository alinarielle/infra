{lib, config, ...}: lib.mkIf config.l.desktop.any.enable {
    services.printing.enable = mkDefault true;
}
