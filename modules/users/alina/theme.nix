{
  opt,
  lib,
  pkgs,
  ...
}:
{
  opt.colors = lib.mkOption {
    type = lib.types.attrs;
  };
  home-manager.users.alina.gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      package = pkgs.sweet-nova;
      name = "Sweet";
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
      theme = {
        package = pkgs.sweet-nova;
        name = "Sweet";
      };
    };
    gtk4 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
      theme = {
        package = pkgs.sweet-nova;
        name = "Sweet";
      };
    };
  };
  l.users.alina.theme.colors = rec {
    black = "#191919";
    white = "#FEFFFE";
    red = "#E83F6F";
    orange = "#FF6C37";
    yellow = "#ECC30B";
    green = "#1CFEBA";
    blue = "#7692FF";
    cyan = "#7ACBF5";
    purple = "#6247AA";
    magenta = "#EA3788";
    pink = "#FF96B0";
    primary = blue;
    secondary = black;
    tertiary = purple;
  };
}
