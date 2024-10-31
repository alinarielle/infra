{
  home-manager = {
    users.alina.programs.home-manager.enable = true;
    users.alina.home = { 
      username = "alina";
      homeDirectory = "/home/alina";
      stateVersion = "23.11";
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
