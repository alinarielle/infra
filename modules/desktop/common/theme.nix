{
  opt,
  lib,
  pkgs,
  ...
}:
let
  sweet = pkgs.stdenv.mkDerivation {
    name = "sweet-theme";
    version = "6.0.0";
    installPhase = ''
      mkdir -p $out/share/themes
      cp -r $src $out/share/themes/Sweet
    '';
    src = pkgs.fetchFromGitHub {
      owner = "EliverLara";
      repo = "Sweet";
      rev = "d70a34a3c6e4d507959524eeeaf91b28b275265b";
      hash = "sha256-7yRtzmvKHUSBldlCthaJMAZDbM4EuMm4Mki6RX04vAA=";
    };
  };
in
{
  opt.colors = lib.mkOption {
    type = lib.types.attrs;
  };
  home-manager.users.alina.gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      package = sweet;
      name = "Sweet";
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
      theme = {
        package = sweet;
        name = "Sweet";
      };
    };
    gtk4 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
      theme = {
        package = sweet;
        name = "Sweet";
      };
    };
  };
  l.desktop.common.theme.colors = rec {
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
