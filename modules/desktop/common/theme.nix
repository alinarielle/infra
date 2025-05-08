{opt, lib, ...}: {
  opt.colors = lib.mkOption { 
    type = lib.types.attrs;
  };
  home-manager.users.alina.gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
  l.desktop.common.theme.colors = rec {
    black = "#191919";
    white = "#FEFFFE";
    red = "#E83F6F";
    orange = "#FF6C37";
    yellow = "#ECC30B";
    green = "#1CFEBA";
    blue = "#7692FF"; #2D9EF4
    cyan = "#7EE8FA";
    purple = "#6247AA";
    magenta = "#EA3788";
    pink = "#FF96B0";
    primary = blue;
    secondary = black;
    tertiary = purple;
  };
}
