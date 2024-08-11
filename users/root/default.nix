{lib, config, ...}: with lib.meta; (lib.mkLocalModule ./. "root user default modules" {
    l.users.root = enable ["ssh"];
}) // {
    imports = [
	./ssh.nix
    ];
}
