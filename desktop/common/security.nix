{lib, config, ...}:
with lib; config.l.lib.mkLocalModule ./security.nix "desktop related security options" {
    services.logind.killUserProcesses = mkDefault true;
    nix.daemonCPUSChedPolicy = mkDefault "idle";
    nix.daemonIOSchedClass = mkDefault "idle";
}
