{config, lib, ...}:
with import ./lib {inherit config lib;};
{
    warnings = ["${builtins.toString (getPort "wireguard")}"];
}
