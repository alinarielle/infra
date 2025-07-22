{lib, nodes, pkgs, ...}: {    
  home-manager.users.alina.programs.ssh = {
    enable = true;
    #addKeysToAgent = "yes";
    controlMaster = "no";
    hashKnownHosts = false;
    extraConfig = "";
    matchBlocks = {
      astolfo = {
        hostname = "astolfo.ip.fef.moe";
        user = "root";
        forwardAgent = true;
      };
      "girldick.gay" = {
        hostname = "girldick.gay";
        user = "root";
      };
    } // lib.mapAttrs (key: val: {
      hostname = key + ".nodes.alina.cx";
      checkHostIP = true;
      addressFamily = "inet6";
      #dynamicForwards = []; #TODO
      #localForwards = []; #TODO
      #remoteForwards = []; #TODO
      #proxyCommand = null; #TODO
      #identityFile = []; #TODO
      #proxyJump = null;
      #sendEnv = [];
      #setEnv = {};
      user = lib.mkDefault "alina";
    }) nodes;
  };
  #home-manager.users.alina.services.ssh-agent.enable = true;
  environment.systemPackages = [ pkgs.pam_rssh ];
  users.users.alina.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMIc3qKtsufY6gVK7UY7KleBaaEexspMtPpv+mGRDNGa alina@fairy"
  ];
}
