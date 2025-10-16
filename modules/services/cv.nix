{ inputs, ... }:
{
  l.network.nginx.vhosts."cv.alina.cx" = {
    root = "${inputs.cv.packages.x86_64-linux.default}";
    locations."/".index = "cv.pdf";
  };
}
