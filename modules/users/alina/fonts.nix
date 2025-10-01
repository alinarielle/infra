{ pkgs, lib, ... }:
let
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
      maintainers = [ "alina" ];
    };
    src = fetchzip {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontPatcher.zip";
      hash = "";
    };
    buildPhase = ''
      mkdir -p $out
      mv font-patcher $out/font-patcher.py
    '';
    dependencies = with python3Packages; [
      fontforge
      configargparse
    ];
  };
  fontPatcherBin = "${fontPatcher}/bin/font-patcher";

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
  toOutputPath =
    path:
    let
      root = ../../..;
    in
    lib.path.removePrefix root path;
  patchNerdFont =
    font: svgDir:
    stdenvNoCC.mkDerivation {
      nativeBuildInputs = [
        fontPatcher
        fontify
      ];
      buildInputs = [ font ];
      buildPhase = ''
        fontify ${svgDir} glyphs.otf
        nerdfont-patcher --careful --custom glyphs.otf -c ${font}
      '';
    };
in
{
  fonts.packages =
    with pkgs;
    [
      roboto-slab
      lato
      source-code-pro
      (pkgs.callPackage ../../../pkgs/fa7.nix { })
    ]
    ++
      map (font: font) # patchNerdFont font ./svg)
        (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts));
}
