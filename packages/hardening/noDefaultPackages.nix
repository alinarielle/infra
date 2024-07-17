{lib, config ,...}: lib.mkLocalModule 
    ./. "removing default packages to minimize attack surface" {
    environment.defaultPackages = lib.mkForce [];
}
