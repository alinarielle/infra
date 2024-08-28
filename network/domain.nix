{lib, config, ...}: lib.mkLocalModule ./. "default domain" {
    networking.domain = lib.mkDefault "infra.alina.cx";
}
