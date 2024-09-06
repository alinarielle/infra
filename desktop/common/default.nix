{pkgs, lib, ...}: {
    imports = [
	#./audio
	./audio.nix
	./bluetooth.nix
	./cursor.nix
	#./documents.nix
	./fonts.nix
	./home-manager.nix
	./hyfetch.nix
	./kitty.nix
	#./layout.nix
	./librewolf.nix
	./mako.nix
	./printing.nix
	./security.nix
	#./stylix.nix
	./theme.nix
	./wayland.nix
	./zathura.nix
    ];
}
