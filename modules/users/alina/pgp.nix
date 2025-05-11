{pkgs, ...}: {
  home-manager.users.alina.services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    enableSshSupport = true;
    defaultCacheTtl = 1800;
    enableExtraSocket = false;
    grabKeyboardAndMouse = true;
    pinentry.package = pkgs.pinentry-tty;
    sshKeys = null; #TODO
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };
  home-manager.users.alina.programs.gpg = {
    enable = true;
    mutableKeys = true;
    mutableTrust = true;
    publicKeys = []; #TODO sops-nix
  };
  services.yubikey-agent.enable = false;
  services.pcscd.enable = true;
  users.users.alina.packages = with pkgs; [
    yubikey-manager gnupg tomb yubico-piv-tool piv-agent
    yubikey-personalization-gui
  ];
}
