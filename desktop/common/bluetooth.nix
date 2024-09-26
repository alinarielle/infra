{self,...}: self.lib.modules.mkLocalModule ./bluetooth.nix "bluetooth"  {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
}
