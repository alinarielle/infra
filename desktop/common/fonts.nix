{lib, config, ...}: config.l.lib.mkLocalModule ./fonts.nix "font config" {
    fonts.packages = with pkgs; lib.mkIf config.l.desktop.any.enable [
	nerdfonts
    ]; #todo exorcist fonts
}
