{
  pkgs, 
  lib, 
  colors, 
  ...
}: let
  prev = "#00d9e4";
  fin = colors.primary;
  #RGBtoHSL = hex: let
    #r = (lib.fromHexString (lib.substring 1 2 hex)) / 255;
    #g = (lib.fromHexString (lib.substring 3 4 hex)) / 255;
    #b = (lib.fromHexString (lib.substring 5 6 hex)) / 255;
    #max = lib.max r (lib.max g b);
    #min = lib.min r (lib.min g b);
    #d = max - min;
    #l = (max + min) / 2;
    #s = if max == min 
      #then 0 
    #else if l > 0.5
      #then d / (2 - max - min)
    #else d / (max + min);
    #h = if max == min 
      #then 0 
    #else if max == r
      #then ((g - b) / d + (if g < b then 6 else 0)) / 6
    #else if max == g
      #then ((b - r) / d + 2) / 6
    #else if max == b
      #then ((r - g) / d + 4) / 6
    #else builtins.throw;
  #in { inherit h s l; };
  s = builtins.toString;
  RGBtoHUE = hex: let
    r = (lib.fromHexString (lib.substring 1 2 hex)) / 255;
    g = (lib.fromHexString (lib.substring 3 4 hex)) / 255;
    b = (lib.fromHexString (lib.substring 5 6 hex)) / 255;
    max = lib.max r (lib.max g b);
    min = lib.min r (lib.min g b);
    hue = if max == r
      then (g - b) / (max - min)
    else if max == g
      then 2 + (b - r) /  (max - min)
    else if max == b
      then 4 + (r - g) / (max - min)
    else builtins.throw "max: ${s max}, min: ${s min}, rgb: ${s r} ${s g} ${s b}";
  in if hue < 0 then hue * 60 + 360 else hue * 60;
  hue_prev = RGBtoHUE prev;
  hue_fin = RGBtoHUE fin;
  hue_mul = hue_fin / hue_prev;
  cmd = lib.escapeShellArgs [
    "${pkgs.imagemagick}/bin/magick"
    ./actiniaria.png
    "-colorspace" "HSL"
    "-channel" "R" "-evaluate" "multiply" (s hue_mul)
    "-channel" "G" "-evaluate" "multiply" "1.15"
    "-channel" "B" "-evaluate" "multiply" "1.0"
    "+channel" "-colorspace" "sRGB"
    "wallpaper.png"
  ];
in pkgs.runCommand "wallpaper" {} ''
  mkdir $out
  ${cmd}
  mv wallpaper.png $out/
''
