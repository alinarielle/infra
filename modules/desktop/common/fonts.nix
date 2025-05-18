{pkgs, lib, ...}: let 
  inherit (pkgs)
    stdenvNoCC
    fetchzip
    python3Packages
    fetchGitHub
    buildFlutterApplication
  ;
  inherit (python3Packages)
    buildPythonApplication
  ;
  fontPatcher = buildPythonApplication {
    version = "4.20.3";
    name = "nerdfont-patcher";
    meta = {
      description = "script for patching glyphs into nerdfonts";
      homepage = "https://www.nerdfonts.com/";
      license = lib.licenses.mit;
      maintainers = ["alina"];
    };
    src = fetchzip {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontPatcher.zip";
      hash = "";
    };
    buildPhase = ''
      mkdir -p $out
      mv source/font-patcher $out/font-patcher.py
    '';
    dependencies = with python3Packages; [fontforge configargparse];
  };
  fontPatcherBin = "${patchScript}/bin/font-patcher";

  fontify = buildFlutterApplication {
    pname = "fontify";
    src = fetchGitHub {
      owner = "westracer";
      repo = "fontify";
      rev = "4191c0a7c35b97aede4ec9aa70d0480f58a4e781";
      hash = "";
    };
    pubspecLock = lib.importJSON ./pubspec.lock.json;
  };
  fontifyBin = "${fontify}/bin/fontify";

  patchNerdFont = font: glyphs@{...}: stdenvNoCC.mkDerivation {
    nativeBuildInputs = [fontPatcher fontify];
    buildInputs = [font];
    buildPhase = ''
      fontify ./svg
      nerdfont-patcher --careful --custom ${font} -c
    '';
  };
in {
  fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
