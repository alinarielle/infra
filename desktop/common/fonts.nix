{self, pkgs, ...}: self.lib.modules.mkLocalModule ./fonts.nix "font config" {
    fonts.packages = with pkgs; [
	nerdfonts
    ]; #todo exorcist fonts
}
