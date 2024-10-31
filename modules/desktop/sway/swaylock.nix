{ pkgs, ... }: {
  home-manager.users.alina = {
    programs.swaylock = {
      enable = true;
      settings = {
	show-failed-attempts = true;
	ignore-empty-password = true;
	color = "322234";
	font = "JetBrainsMono Nerd Font";
      };
    };
    services.swayidle = let
      lockCommand = "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --effect-blur 20x10";
    in {
      enable = true;
      events = [
        { event = "before-sleep"; command = lockCommand; }
        { event = "lock"; command = lockCommand; }
      ];
      timeouts = [
        { timeout = 300; command = lockCommand; }
      ];	
    };
  };
}
