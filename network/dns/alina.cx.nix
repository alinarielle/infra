{nix-dns,...}: {
    net.dns.zones."alina.cx" = {
	A = [
	    { address = "217.160.219.238"; }
	];
    };
}
