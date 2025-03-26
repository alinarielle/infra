{
  pkgs ? import <nixpkgs> {},
  ...
}: pkgs.dockerTools.buildImage {
  name = "k8sOCIalism";
  tag = "latest";

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = [ pkgs.kubernetes ];
    pathsToLink = [ "/bin" "/var" "/usr" "/opt" ];
  };

  runAsRoot = ''
    mkdir -p /data
  '';

  config = {
    Cmd = [ "${pkgs.tmate}/bin/tmate" ];
    WorkingDir = "/data";
    Volumes = { "/data" = { }; };
  };
}
