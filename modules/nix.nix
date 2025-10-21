{ inputs, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.nix-output-monitor ];
  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "@wheel"
        "root"
      ];
      allowed-users = [
        "@wheel"
        "root"
      ];
    };
    optimise = {
      automatic = true;
      dates = [ "03:45" ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
  nixpkgs = {
    config = {
      #allowUnfree = true;
      permittedInsecurePackages = [
        "olm-3.2.16"
      ];
    };
    flake = {
      setNixPath = true;
      # source = self.outPath;
    };
  };
}
