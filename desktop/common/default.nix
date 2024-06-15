{pkgs, lib, ...}: {
    imports = [
	./librewolf.nix
	./stylix.nix
	./cursor.nix
	./kitty.nix
	./mako.nix
	./zathura.nix
	./audio.nix
	./pkgs.nix
	./bluetooth.nix
	./fonts.nix
    ];

    services.printing.enable = true;

    nix.daemonCPUSchedPolicy = lib.mkDefault "idle";
    nix.daemonIOSchedClass = lib.mkDefault "idle";
}
