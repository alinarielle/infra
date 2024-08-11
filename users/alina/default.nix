{lib, config, ...}: {
    imports = [
	./shell.nix
	./helix.nix
	./pkgs.nix
	./nvim.nix
	./git.nix
	./ssh.nix
	./user.nix
	./home-manager.nix
    ];
} // (lib.mkLocalModule ./. "alina's user config" {
    l.users.alina = enable ["helix" "git" "nvim" "ssh" "user" "home-manager"];
})
