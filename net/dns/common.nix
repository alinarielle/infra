{config, nix-dns, ...}: with nix-dns.lib.combinators; {
    TTL = 3600;
    SOA = {
	nameServer = if config.net.dns.primary
	    then "ns1.alina.cx";
	    else "ns2.alina.cx";
	serial = 2024051212;
	adminEmail = "dnsadmin@alina.cx";
	ttl = 3600;
    };
    CAA = letsEncrypt "acme@alina.cx";
    NS = [
	"ns1.alina.cx"
	"ns2.alina.cx"
    ];
}
