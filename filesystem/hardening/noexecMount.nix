{lib, config, ...}: {
    options.l.filesystem.hardening.noexecMount.enable = 
	lib.mkEnableOption "mount every partition as noexec except the nix store";
    config = lib.mkIf config.l.filesystem.hardening.noexecMount.enable {
	fileSystem = 
    };
}# lib.extends over config.fileSystems to mark all of them as noexec except for the
# /nix/store mount
