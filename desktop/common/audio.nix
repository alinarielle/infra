{self, ...}: self.lib.modules.mkLocalModule ./audio.nix "audio settings" {
    sound.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
	enable = true;
	audio.enable = true;
    };
}
