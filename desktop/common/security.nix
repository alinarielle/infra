{self, ...}: self.lib.modules.mkLocalModule ./security.nix "desktop related security options" {
    services.logind.killUserProcesses = true;
    nix.daemonCPUSChedPolicy = "idle";
    nix.daemonIOSchedClass = "idle";
}
