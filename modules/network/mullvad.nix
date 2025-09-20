{ pkgs, config, ... }:
{
  sops.secrets.mullvad-berlin = {
    sopsFile = ../../secrets/global.yaml;
  };
  networking.wireguard = {
    interfaces.mullvad-berlin = {
      privateKeyFile = config.sops.secrets.mullvad-berlin.path;
    };
  };
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad;
  environment.systemPackages = [ pkgs.mullvad ];
}
