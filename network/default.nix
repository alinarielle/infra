{lib, pkgs, ...}: {
    imports = [ 
	./congestion
	#./dns
	#./dns.nix
	./domain.nix
	#./getAddress.nix
	./getPort.nix
	./hardening
	./hostName
	#./initrdUnlock.nix
	#./mesh-wip.nix
	./networkmanager.nix
	./rnat.nix
	./speed.nix
	#./ssh-forward.nix
	#./ssh-net.nix
	./sshd.nix
	./time.nix
	#./web
	#wg-mesh.nix
    ];
}
