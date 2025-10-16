{
  pkgs,
  opt,
  cfg,
  lib,
  ...
}:
let
  unboundQuic = pkgs.unbound-full.overrideAttrs (previousAttrs: {
    configureFlags = [
      "--with-ssl=${pkgs.quictls.dev}"
      "--with-libngtcp2=${pkgs.libngtcp2.dev}"
      "LDFLAGS='-Wl,-rpath -Wl,${pkgs.libngtcp2.dev}/lib'"
    ]
    ++ (lib.tail previousAttrs.configureFlags);
  });
in
{
  opt.forwardingOnly = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };
  services.unbound = {
    enable = true;
    resolveLocalQueries = true;
    #package = unboundQuic;
    enableRootTrustAnchor = true;
    settings = {
      server = {
        qname-minimisation = true;
        interface = "0.0.0.0";
        access-control = "127.0.0.1"; # TODO wg-mesh
      };
      forward-zone = lib.mkIf cfg.forwardingOnly [
        {
          name = ".";
          forward-addr = [
            "1.1.1.1@853#cloudflare-dns.com"
            "1.0.0.1@853#cloudflare-dns.com"
          ];
        }
      ];
      remote-control.control-enable = false;
    };
  };
}
