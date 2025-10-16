{
  home-manager = {
    users.root.programs.home-manager.enable = true;
    users.root.home = {
      username = "root";
      homeDirectory = "/root";
      stateVersion = "23.11";
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}
