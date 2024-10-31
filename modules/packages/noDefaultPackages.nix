{lib, ...}: {
    environment.defaultPackages = lib.mkForce [];
    # remove default packages to minimize attack surface
}
