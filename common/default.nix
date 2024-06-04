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
    nix.settings.extra-substituters = [
	"https://cache.lix.systems"
    ];
     nix.settings.trusted-public-keys = [
	"cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    ];
    environment.systemPackages = with pkgs; [
	tlp
	avahi
	acpid
	kitty.terminfo
    ];

    services.logind.killUserProcesses = true;

    time.timeZone = lib.mkDefault "Europe/Berlin";
}
