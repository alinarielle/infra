{self,...}: self.lib.modules.mkLocalModule ./printing.nix "cupsd" {
    services.printing.enable = true;
}
