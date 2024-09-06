{pkgs, lib, config, ... }: config.l.lib.mkLocalModule 
    ./wayland.nix 
    "common wayland related fixes and settings"  
    {
    users.users.alina.packages = with pkgs; [
	qt5.qtwayland
	waypipe
	wl-clipboard
	wlprop
	wev
	wf-recorder
	grimblast
	sway-launcher-desktop # take out if non window manager wayland profiles are made
    ];

    environment.sessionVariables = {
	SDL_VIDEODRIVER = "wayland";
	QT_QPA_PLATFORM = "wayland";
	QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # same as in the comment before
	_JAVA_AWT_WM_NONPARENTING = "1";
	NIXOS_OZONE_WL = "1";
    };
}
