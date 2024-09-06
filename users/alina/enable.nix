{lib, config, ...}: {
    options.l.users.alina.enable = lib.mkEnableOption "shortcut to activate all";
    config = lib.mkIf config.l.users.alina.enable {
	l.users.alina = config.l.lib.enable [
	    "git" "helix" "home-manager" "nvim" "ssh" "user"
	];
    };
}
