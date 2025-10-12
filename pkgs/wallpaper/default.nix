{
  pkgs,
  lib,
  colors,
  ...
}:
let
  prev = "#00d9e4";
  fin = colors.primary;
  repo = builtins.fetchGit {
    url = "https://codeberg.org/alinarielle/flake.git";
    rev = "4892aa668f3f0f8c2390414bb78b12c47fad3e1c";
    ref = "main";
    allRefs = true;
  };
  image = "${repo}/pkgs/wallpaper/actiniaria.png";
  s = builtins.toString;
  RGBtoHUE =
    hex:
    let
      r = (lib.fromHexString (lib.substring 1 2 hex)) / 255.0;
      g = (lib.fromHexString (lib.substring 3 2 hex)) / 255.0;
      b = (lib.fromHexString (lib.substring 5 2 hex)) / 350.0;
      max = lib.max r (lib.max g b);
      min = lib.min r (lib.min g b);
      h =
        if max == r then
          (g - b) / (max - min)
        else if max == g then
          2 + (b - r) / (max - min)
        else if max == b then
          4 + (r - g) / (max - min)
        else
          builtins.throw "what";
      hue = if h < 0 then h * 60 + 360 else h * 60;
      trace = "max: ${s max}, min: ${s min}, rgb: ${s r} ${s g} ${s b}, h: ${s h}, hue: ${s hue}";
    in
    hue;
  hue_prev = RGBtoHUE prev;
  hue_fin = RGBtoHUE fin;
  hue_mul = hue_fin / hue_prev;
  cmd = lib.escapeShellArgs [
    "${pkgs.imagemagick}/bin/magick"
    image
    "-colorspace"
    "HSL"
    "-channel"
    "R"
    "-evaluate"
    "multiply"
    (s (hue_mul))
    "-channel"
    "G"
    "-evaluate"
    "multiply"
    "1.25"
    "-channel"
    "B"
    "-evaluate"
    "multiply"
    "1.0"
    "+channel"
    "-colorspace"
    "sRGB"
    "wallpaper.png"
  ];
in
pkgs.runCommand "wallpaper" { } ''
  mkdir $out
  ${cmd}
  mv wallpaper.png $out/
''
