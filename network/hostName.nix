{lib, config, name, ...}: lib.mkLocalModule ./. "default networking host name" {
    networking.hostName = lib.mkDefault name;
}
