{config, ...}:
let check = config.environment.persistence ? "/persist"; in {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    environment.persistence."/persist".directories = mkIf check [ "/var/lib/bluetooth" ];
}
