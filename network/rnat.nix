{lib,config,inputs,...}: config.l.lib.mkLocalModule ./rnat.nix "module for yuyu's rnat" {
    system.environmentPackages = [ inputs.rnat.packages.default ];
}
