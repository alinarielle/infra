{
  pkgs, 
  lib, 
  config,
  colors ? config.l.desktop.theme.colors, 
  ...
}: let
  prev_color = "00d9e4";
  fin_color = lib.substring 1 6 colors.primary;
  prev_red = lib.fromHexString (lib.substring 0 1 prev_color);
  red = lib.fromHexString (lib.substring 0 1 colors.primary);
  green =;
  blue =;
  hue_angle = lib.fromHexString colors.primary;
  HUE = hue_angle * 100/180 + 100;
in pkgs.runCommand "wallpaper" {} ''
  mkdir $out
  ${pkgs.imagemagick}/bin/magick ${./actiniaria.png} \
    -colorspace HSL \
    -channel R -evaluate multiply ${red} \ 
    -channel G -evaluate multiply ${green} \ 
    -channel B -evaluate multiply ${blue} \ 
    +channel -colorspace sRGB wallpaper.png

  mv wallpaper.png $out/
''
