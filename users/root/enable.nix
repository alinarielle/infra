{lib, config, ...}: {
    options.l.users.root.enable = lib.mkEnableOption "shortcut to activate all";
    config = lib.mkIf config.l.users.root.enable {
	l.users.root = config.l.lib.enable [
	    "ssh"
	];
    };
}
