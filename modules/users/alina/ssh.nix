{lib, nodes, pkgs, ...}: {    
  home-manager.users.alina.programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    controlMaster = "no";
    hashKnownHosts = false;
    forwardAgent = false;
    extraConfig = "";
    matchBlocks = lib.mapAttrs (key: val: {
      hostname = key + ".nodes.alina.cx";
      checkHostIP = true;
      addressFamily = "inet6";
      dynamicForwards = []; #TODO
      localForwards = []; #TODO
      remoteForwards = []; #TODO
      proxyCommand = null; #TODO
      identityFile = []; #TODO
      proxyJump = null;
      sendEnv = [];
      setEnv = {};
      user = lib.mkDefault "alina";
    }) nodes;
  };
  home-manager.users.alina.services.ssh-agent.enable = true;
  environment.systemPackages = [ pkgs.pam_rssh ];
  users.users.alina.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINz9IXSb6I5uzk+tl4HAiBeCFwB+hD2owIvLyIirER/D alina"
  ];
}
