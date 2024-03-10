{pkgs, ...}: {
    imports = [
	./kernel.nix
    ];
    nix.gc = {
	automatic = true;
	options = "--delete-older-than 7d";
    };
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
	tlp
	avahi
	acpid
    ];
}
