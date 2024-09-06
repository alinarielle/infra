{ pkgs, config, inputs, lib, ... }: {
    imports = [
	./keybinds.nix
	./config.nix
	./hyprlock.nix
	./hypridle.nix
	./waybar.nix
	./enable.nix
    ];    

}

