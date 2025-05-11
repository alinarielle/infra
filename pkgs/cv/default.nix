{pkgs, ...}: pkgs.stdenv.mkDerivation {
  name = "cv";
  src = pkgs.fetchFromGitLab {
    rev = "465ef29bcc6bf77bcfe5606eb05bd8eca685175c";
    hash = "sha256-vWgO8ajMQymk8xv4PUwMXi0UbjH1dmfD3+lM6K2R4m4=";
    owner = "alina";
    repo = "cv";
    domain = "cyberchaos.dev";
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
    pdflatex main.tex
  '';
  installPhase = ''
    mkdir -p $out
    cp main.pdf $out/cv.pdf
  '';
}
