{
  services.logind.settings.Login.KillUserProcesses = false;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
}
