{config, ...}: with config.l.lib; {
  l.profiles = enable ["shell"];
}
# connect to wireguard site hosted on eris
# announce its host name to other peers 
# ARP? PDP? DHCPv6? wireguard mesh first
# open sshd to internal management network, with internal dns on <node>.nodes.alina.cx

