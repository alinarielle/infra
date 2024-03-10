{pkgs, ...}: {
    imports = [
	./kernel.nix
    ];
    nix.gc = {
	automatic = true;
	options = "--delete-older-than 7d";
    };
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.auto-optimise-store = true;
    nixpkgs.config

    environment.systemPackages = with pkgs; [
	tlp
	avahi
	acpid
	kitty.terminfo
    ];

    security.logind.killUserProcesses = true;
}
