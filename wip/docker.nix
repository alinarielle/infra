{name, pkgs, config, opt, cfg, lib, ...}: with pkgs.dockerTools; let
image = buildImage {
  name = name + "oci";
  tag = "latest";
  
  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = with pkgs; [
      kubernetes
      kubectl
      cacert
      bashInteractive
      coreutils
      fakeNss
      binSh
    ]; 
    #++ config.environment.systemPackages
    #++ config.users.users.alina.packages;
  };

  runAsRoot = ''
  '';
};
in {
  virtualisation.docker = {
    enable = true;
    storageDriver = lib.mkDefault "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  environment.systemPackages = [image];
}

#GOAL: generate OCI compliant images of nodes for deployment with fly.io
# https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-dockerTools
# https://wiki.nixos.org/wiki/Docker#Creating_images_with_Nix
