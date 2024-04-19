{pkgs, lib, ...}: {
    imports = [
	#./kernel.nix
	../users
	./bootloader.nix
	../network
    ];
    nix.gc = {
	automatic = true;
	options = "--delete-older-than 7d";
    };
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.settings.trusted-users = [
	"@wheel"
	"root"
    ];
    nixpkgs.config.auto-optimise-store = true;

    environment.systemPackages = with pkgs; [
	tlp
	avahi
	acpid
	kitty.terminfo
    ];

    services.logind.killUserProcesses = true;

    time.timeZone = lib.mkDefault "Europe/Berlin";
}
