{lib, config, ...}: config.l.lib.mkLocalModule ./audio.nix "audio settings" {
    sound.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
	enable = true;
	audio.enable = true;
    };
}
