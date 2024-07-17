{lib, config, ...}:
with lib; mkIf config.l.desktop.any.enable {
    services.logind.killUserProcesses = mkDefault true;
    nix.daemonCPUSChedPolicy = mkDefault "idle";
    nix.daemonIOSchedClass = mkDefault "idle";
}
