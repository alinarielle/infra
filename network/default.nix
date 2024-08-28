{lib, pkgs, ...}: {
    imports = [ 
	./congestion
	./time.nix
	./domain.nix
	./hostName.nix
	./hardening
	./getPort.nix
	./networkmanager.nix
	./rnat.nix
	./ssh-net.nix
    ];
}
