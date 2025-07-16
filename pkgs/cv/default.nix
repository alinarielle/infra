{pkgs, ...}: pkgs.stdenv.mkDerivation {
  name = "cv";
  src = pkgs.fetchgit {
    url = "https://git.gay/alina/jobs";
    hash = "sha256-8+tje+0HpKlW9LlIcoougWjqxrt2ChxExgshITxZzHA=";
    rev = "5902b5d6d307c716ca17691885c297c7a70d4404";
  };
  nativeBuildInputs = with pkgs.texlivePackages; [
    scheme-basic dvisvgm dvipng
    extsizes etoolbox pdfx xcolor xmpincl
    accsupp fontawesome5 koma-script cmap
    ragged2e tikz-page pgf tcolorbox environ
    tikzfill enumitem adjustbox dashrule
    ifmtarg multirow changepage paracol roboto
    fontaxes lato booktabs
    wrapfig amsmath ulem hyperref capt-of
    pkgs.texliveFull
  ];
  buildPhase = ''
    cd ./cv
    pdflatex main.tex
  '';
  installPhase = ''
    mkdir -p $out
    cp main.pdf $out/cv.pdf
  '';
}
