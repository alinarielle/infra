{    
  home-manager.users.alina.programs.ssh = {
    enable = true;
  };
  users.users.alina.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINz9IXSb6I5uzk+tl4HAiBeCFwB+hD2owIvLyIirER/D alina"
  ];
}
