{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.kitty.terminfo ];
  services.logind.settings.Login.KillUserProcesses = false;
  services.openssh = {
    enable = true;
    openFirewall = true;
    allowSFTP = true;
    extraConfig = ''
      AllowTcpForwarding yes
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
    settings = {
      UseDns = true;
      X11Forwarding = false;
      PrintMotd = true;
      PermitRootLogin = "prohibit-password";
      AllowUsers = [
        "root"
        "alina"
      ];
      PasswordAuthentication = false;
      challengeResponseAuthentication = false;
    };
  };
}
