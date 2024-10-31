{
  home-manager.users.alina.programs.git = {
    enable = true;
    userName = "alina";
    userEmail = "alina@duck.com";
    signing.signByDefault = true;
    signing.key = "2323A23A5326C368D2EA25E851D817D1174AFD62";
    extraConfig = {
      init.defaultBranch = "main";
      tag.gpgSign = true;
      feature.manyFiles = true;
    };
  };
}
