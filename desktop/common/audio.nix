{lib, config, ...}: lib.mkIf config.l.desktop.any.enable {
    sound.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
	enable = true;
	audio.enable = true;
    };
}
