{pkgs, ...}: {
    home.username = "alina";
    home.homeDirectory = "/home/alina";
    home.stateVersion = "23.11"; # To figure this out you can comment out the line and see what version it expected.
    programs.home-manager.enable = true;
}
