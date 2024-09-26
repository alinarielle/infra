{
    imports = [
        ({lib, config, pkgs, ...}: let x = (with config.l.lib; mkLocalModule ./base.nix "base profile" {}); in builtins.trace (builtins.typeOf x) x)
	({lib, config, pkgs, ...}: builtins.trace "yep" {})
#	./profiles
#	./hidpi.nix
#	./nix.nix
	./mkLocalModule.nix
	./enable.nix
	./lib.nix
    ];
}
