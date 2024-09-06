{lib, config ,...}: config.l.lib.mkLocalModule 
    ./noDefaultPackages.nix
    "removing default packages to minimize attack surface" 
{
    environment.defaultPackages = lib.mkForce [];
}
