{lib, config, pkgs, ...}:
with lib; with builtins;
{
    l.sshd.enable = true;
    l.kernel.hardened.enable = true;
}
