{config, inputs, lib, ...}: with config.l.lib; {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];
  l.profiles = enable ["shell"];
  l.services.jellyfin.enable = true;
  system.stateVersion = "25.05";
  deployment.targetHost = "alina.dog";

  networking.interfaces.enp41s0.ipv6 = {
    addresses = [{
      address = "2a01:4f8:a0:8246::";
      prefixLength = 64;
    }];
    routes = [{ 
      address = "fe80::1"; 
      prefixLength = 128;
    }];
  };
  networking.defaultGateway6 = {
    address = "fe80::1";
    interface = "enp41s0";
  };
}
