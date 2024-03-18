{pkgs, lib, ...}: {
    imports = [
	#./kernel.nix
	../users
	./bootloader.nix
    ];
    nix.gc = {
	automatic = true;
	options = "--delete-older-than 7d";
    };
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.auto-optimise-store = true;

    environment.systemPackages = with pkgs; [
	tlp
	avahi
	acpid
	kitty.terminfo
    ];

    services.logind.killUserProcesses = true;

    users.users.root.openssh.authorizedKeys.keys = [
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINz9IXSb6I5uzk+tl4HAiBeCFwB+hD2owIvLyIirER/D alina@duck.com"
    ];
    time.timeZone = lib.mkDefault "Europe/Berlin";
}
