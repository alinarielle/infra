{lib, config, name, ...}: config.l.lib.mkLocalModule 
    ./hostName.nix 
    "default networking host name" 
{
    networking.hostName = lib.mkDefault name;
}
