{lib, config, ...}:
with lib; with builtins;
let
    cfg = config.l.desktop.impermanence;
in {
    options.l.desktop.impermanence.enable = mkEnableOption "impermanent /home layout";
    config = mkIf (cfg.enable && config.l.desktop.any.enable) {
	systemd.tmpfiles.settings.snowy = genAttrs 
	    (map (uwu: "/home/alina/" + uwu )[
		"src"
		"docs"
		"media"
		"media/pics"
		"media/videos"
		"media/audio"
		"media/books"
		"downloads"
	    ])
	    {
		group = alina;
		user = alina;
		mode = "770";
		age = "-";
		type = "d";
	    };
	l.impermanence.keep = filter 
	    (x: !(any (y: x == y) (map (uwu: "/home/alina/" + uwu) [ 
		"downloads" "media"
	    ]))) 
	    (attrNames config.systemd.tmpfiles.settings.snowy)
	++ map (x: "/home/alina/" + x) [".zsh_history"];

    };
}
