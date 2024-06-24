{lib, ...}:
with lib;
{
    services.logind.killUserProcesses = mkDefault true;
    nix.daemonCPUSChedPolicy = mkDefault "idle";
    nix.daemonIOSchedClass = mkDefault "idle";

}
