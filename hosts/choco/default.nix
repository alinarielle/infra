{config, lib, inputs, ...}: with config.l.lib; {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./disko.nix
  ];
  l.profiles = enable ["workstation"];
  system.stateVersion = "25.05";
}
