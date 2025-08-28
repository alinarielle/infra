{inputs, lib, opt, cfg, pkgs, ...}: let
  beescript = pkgs.fetchzip {
    url = "https://gist.github.com/MattIPv4/045239bc27b16b2bcf7a3a9a4648c08a/archive/2411e31293a35f3e565f61e7490a806d4720ea7e.zip";
    hash = "sha256-fAo24TjxR6d1w7VZWRmekf0ONvm2CUtx6Ddv4Giec8M=";
  };
in {
  opt.servers = lib.mkOption { default = {}; type = lib.types.attrs; };
  imports = [inputs.nixocaine.nixosModules.default];
  services.iocaine = {
    servers = lib.mapAttrs 
      (key: val: {
        enable = true;
        server = {
          bind = "/run/iocaine/iocaine.socket";
          unix_listen_access = "group";
        };
        sources = {
          words = "${pkgs.rockyou}/share/wordlists/rockyou.txt";
          markov = ["${beescript}/bee movie script"];
        };
        generator.initial_seed = "";
      } // val) 
      cfg.servers;
  };
  l.network.nginx = {
    upstreams.iocaine.servers."unix:/run/iocaine/iocaine.socket" = {};
  };
}
