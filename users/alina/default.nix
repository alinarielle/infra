{lib, config, ...}: {
    imports = [
	./enable.nix
	./git.nix
	./helix.nix
	./home-manager.nix
	./nvim.nix
	./ssh.nix
	./user.nix
    ];
}
