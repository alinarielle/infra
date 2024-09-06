{lib, config, ...}:
with lib; with builtins; config.l.lib.mkLocalModule ./layout.nix "impermanent /home" { 
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
}
