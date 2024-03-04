{pkgs, ...}: {
    imports = [ ./sway ];

    users.users.alina.packages = with pkgs; [
	monero-gui
    ];
}
