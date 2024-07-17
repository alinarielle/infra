{pkgs, lib, ...}: {
    imports = [
	./librewolf.nix
	./home-manager.nix
	./security.nix
	./stylix.nix
	./cursor.nix
	./kitty.nix
	./mako.nix
	./zathura.nix
	./audio.nix
	./pkgs.nix
	./bluetooth.nix
	./fonts.nix
	./layout.nix
	./fonts.nix
	./theme.nix
	./printing.nix
	./hyfetch
    ];
}
