{pkgs,...}: {
  l.network.nginx.vhosts."cv.alina.cx" = {
    root = "${import ../../pkgs/cv {inherit pkgs;}}";
    locations."/".index = "cv.pdf";
  };
}
