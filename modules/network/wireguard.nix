{
  opt,
  pkgs,
  cfg,
  lib,
  config,
  nodes,
  name,
  inputs,
  ...
}:
let
  peersConfig = lib.filterAttrs (key: val: val.config.l.network.wireguard.enable) nodes;
  makeTunnel =
    {
      peers ? cfg.tunnel.peers,
    }@args:
    {

    };
  privateKeyGenerateScript =
    let
      wg = "${pkgs.wireguard-tools}/bin/wg";
    in
    pkgs.runCommandLocal "generate-private-key" { } ''
      set -e
      mkdir -p --mode 0755 "${builtins.dirOf cfg.privateKeyFile}"

      if [ ! -f "${cfg.privateKeyFile}" ]; then
      (set -e; umask 077; wg genkey > "${cfg.privateKeyFile}")
      fi
    '';
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  opt = with lib.types; {
    tunnel = {
      make = lib.mkOption {
        type = functionTo attrs;
        default = makeTunnel;
      };
      peers = lib.mkOption {
        default = null;
        type = nullOr (
          listOf submodule {
            options = {
              host = lib.mkOption { type = enum (filter (x: x != name) (attrNames nodes)); };
              publicKeyFile = lib.mkOption { type = path; };
              fqdn = lib.mkOption {
                type = nullOr str;
                default = null;
              };
              keepAlive = lib.mkOption {
                type = nullOr int;
                default = 25;
              };
            };
          }
        );
      };
      rosenpass = lib.mkOption {
        type = bool;
        default = true;
      };
      privateKeyFile = lib.mkOption {
        type = path;
        default = 1;
      };
      publicKeyFile = lib.mkOption {
        type = path;
        default = "/secrets/wireguard/${name}/wg.public";
      };
      presharedKeyFile = lib.mkOption { type = path; };
      proxyTo = lib.mkOption {
        type = either (enum [ null ]) (enum (attrNames nodes));
        default = null;
        description = ''
          change to the hostname to use that node as proxy, 
          			or leave as null to disable'';
      };
      proxyOthers = lib.mkEnableOption "whether to forward the entire traffic of peers";
      port = lib.mkOption {
        type = port;
        default = config.l.network.getPort "wireguard";
      };
      interface = {
        name = lib.mkOption { type = str; };
        #restrictToInterface = lib.mkOption { type = bool; default = true; };
      };
      ip = {
        v6 = {
          enable = lib.mkOption {
            type = bool;
            default = true;
          };
          private = lib.mkOption {
            type = str;
            default =
              with (import ../../lib/ip-util.nix { }).ipv6;
              let
                alphabet = (lib.filter (x: x != "") (lib.splitString "" "abcdefghijklmnopqrstuvwxyz"));
                dividend = lib.toIntBase10 (
                  builtins.substring 0 19 (
                    alphabet (lib.imap (int: v: builtins.toString int) alphabet) (
                      builtins.hashString "sha256" "wg-${name}"
                    )
                  )
                );
              in
              encode (
                (decode "fc00::/7") # 7-bit special ULA range prefix
                + (decode "100::/8") # 1-bit L bit, since prefix is locally assigned
                + (lib.mod dividend # pseudo-random entropy source
                  (decode "0000:ffff:ffff::/40")
                ) # 40-bit Global ID range
                + (decode "0:0:0:acab::/64") # 16-bit subnet ID
                + (decode "::1/128") # 64-bit Interface ID
              );
          };
          fqdn = lib.mkOption {
            type = nullOr str;
            default = config.networking.fqdn;
          };
        };
      };
    };
  };
  config = {
    assertions = [
      {
        assertion =
          if !cfg.tunnel.proxyOthers then
            (!(lib.any (x: name == x.config.l.network.wireguard.tunnel.proxyTo) (lib.attrValues peersConfig)))
          else
            true;
        message = "(an)other host(s) selected you as proxy, but you denied being a proxy!";
      }
    ];
    l.network.wireguard.tunnel.peers = [
      {
        peer = "eris";
        relPeerPublicKey = "/wireguard/eris/wg.public";
      }
    ];
    #systemd.network = cfg.tunnel.make {};
    #services.rosenpass = lib.mkIf cfg.tunnel.rosenpass.enable {
    #enable = true;
    #settings = {};
    #};
    #networking.wireguard = {};
    #networking.wg-quick = {};
  };
}
#provide an interface for creating wg tunnels, meshs, routed meshs,
#support port forwarding
#expose modules that activate specific mesh configurations and conflict with others
#from these do systemd-run and terraform
#create collection of environmental facts, like hidpi or disk or ip addresses
#create network interface for every tunnel and create mesh interfaces as bridges
#also handle VMs
#get public primary address from environment facts
#sops secret management
#integrate mullvad
#ability to use this in systemd services and restrict all traffic to the intercface
#package every host's cryptographic public identity
