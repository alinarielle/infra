{config, lib, self,...}: self.lib.modules.mkLocalModule ./mako.nix "notification daemon" {
    home-manager.users.alina.services.mako = let
	color = config.colorScheme.palette;
    in {
	enable = true;
	backgroundColor = "#${color.grey}";
	borderColor = "#${color.blue}";
	
	borderRadius = 5;
	borderSize = 2;

	height = 100;
	
	defaultTimeout = 5000;

	font = "JetBrainsMono Nerd Font 10";
    };
}
