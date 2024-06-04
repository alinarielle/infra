{lib, config, ...}:
with lib; with builtins; with import ../lib {inherit lib config;}; {
    services.restic.server = {
	enable = true;
	dataDir = "/var/lib/restic";
	prometheus = true;
	privateRepos = true;
	listenAddress = ":" + toString getPort "restic";
	appendOnly = true;
    };
    dns. => restic.alina.cx
    s3, tls
}
