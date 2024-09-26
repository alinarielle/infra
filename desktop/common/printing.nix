{lib, config, ...}: config.l.lib.mkLocalModule ./printing.nix "cupsd" {
    services.printing.enable = mkDefault true;
}
