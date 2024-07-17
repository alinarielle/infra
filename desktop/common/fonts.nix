{lib, config, ...}:
{
    fonts.packages = with pkgs; lib.mkIf config.l.desktop.any.enable [
	nerdfonts
    ]; #todo exorcist fonts
}
