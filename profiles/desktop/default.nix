{pkgs, lib, ...}: {
    imports = [
	./sway
	./librewolf.nix
	./cursor.nix
	./kitty.nix
	./mako.nix
	./zathura.nix
    ];

    users.users.alina.packages = with pkgs; [
	monero-gui
	spotify
	mpv
	mpvpaper
	pinentry-qt
	tor-browser
	krita
	librewolf
	element-desktop
	android-file-transfer
	kitty
	bluez
	keepassxc
	noisetorch
	prismlauncher
	qbittorrent
	signal-desktop
	standardnotes
	telegram-desktop
	thunderbird
	ungoogled-chromium
	virt-manager
	wireplumber
	zathura
    ];
    fonts.packages = with pkgs; [
	nerdfonts
    ];

    services.printing.enable = true;

    sound.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
	enable = true;
	audio.enable = true;
    };
    
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    nix.daemonCPUSchedPolicy = lib.mkDefault "idle";
    nix.daemonIOSchedClass = lib.mkDefault "idle";
}
