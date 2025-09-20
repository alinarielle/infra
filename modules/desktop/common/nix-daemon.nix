{
  services.logind.settings.Login.KillUserProcesses = true;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";
}
