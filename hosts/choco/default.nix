{config, lib, inputs, ...}: with config.l.lib; {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];
  l.desktop.kde = enable ["config"];
  l.desktop.common.bluetooth.enable = lib.mkForce false;
  l.profiles = enable ["base" "hardened"];
  l.filesystem = enable ["impermanence"];
  system.stateVersion = "25.05";
}
