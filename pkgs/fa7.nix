{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
let
  font-awesome =
    {
      version,
      hash,
      rev ? version,
    }:
    stdenvNoCC.mkDerivation {
      pname = "font-awesome";
      inherit version;

      src = fetchFromGitHub {
        owner = "FortAwesome";
        repo = "Font-Awesome";
        inherit rev hash;
      };

      installPhase = ''
        runHook preInstall

        install -m444 -Dt $out/share/fonts/opentype {fonts,otfs}/*.otf

        runHook postInstall
      '';

      meta = with lib; {
        description = "Font Awesome - OTF font";
        longDescription = ''
          Font Awesome gives you scalable vector icons that can instantly be customized.
          This package includes only the OTF font. For full CSS etc. see the project website.
        '';
        homepage = "https://fontawesome.com/";
        license = licenses.ofl;
        platforms = platforms.all;
        maintainers = with maintainers; [
          abaldeau
          johnazoidberg
        ];
      };
    };
in
font-awesome {
  version = "7.0.0";
  hash = "sha256-S8i8KIcDbHwmnJ2JjYleD0cmh9YGuzF+hGzlruTRZIk=";
}
