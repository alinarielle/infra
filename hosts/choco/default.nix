{config, lib, inputs, ...}: with config.l.lib; {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./disko.nix
  ];
  l.profiles = enable ["desktop"];
  l.filesystem.ceph.enable = true;
  system.stateVersion = "25.05";
}
