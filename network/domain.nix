{lib, config, ...}: config.l.lib.mkLocalModule ./domain.nix "default domain" {
    networking.domain = lib.mkDefault "infra.alina.cx";
}
