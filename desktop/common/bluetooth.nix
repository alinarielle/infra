{config, lib, ...}: config.l.lib.mkLocalModule ./bluetooth.nix "bluetooth"  {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
}
