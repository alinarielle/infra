{ pkgs, config, inputs, lib, ... }: {
    options.l.desktop.hyprland.enable = lib.mkEnableOption "hyprland";
    imports = [
	./keybinds.nix
	./config.nix
	./hyprlock.nix
	./hypridle.nix
	./waybar.nix
    ];    

}

