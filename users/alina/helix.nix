{lib, config, ...}: config.l.lib.mkLocalModule ./helix.nix "helix config for alina" {
    home-manager.users.alina.programs.helix = {
	defaultEditor = true;
	enable = true;
	settings = {
	    editor = {
		line-number = "relative";
		lsp.display-messages = true;
		mouse = false;
		file-picker.hidden = false;
	    };
	};
    };
}
