{config, pkgs, ...}: with config.l.lib; {
  l.profiles = enable ["shell"];
  imports = [
    "${pkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    "${pkgs}/nixos/modules/installer/cd-dvd//installation-cd-graphical-calamares-plasma6.nix"
  ];
}
# connect to wireguard site hosted on eris
# announce its host name to other peers 
# ARP? PDP? DHCPv6? wireguard mesh first
# open sshd to internal management network, with internal dns on <node>.nodes.alina.cx

