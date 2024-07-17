{config, lib, ...}: lib.mkIf config.l.desktop.any.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
}
