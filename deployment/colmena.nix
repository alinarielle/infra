{lib, config, ...}:
with lib; with builtins; lib.mkLocalModule "colmena configuration" {
    deployment = mkDefault {
	targetUser = "alina";
	allowLocalDeployment = mkIf (elem "desktop" config.deployment.tags) true;
	tags = [ "infra" (mkIf (elem "desktop" config.deployment.tags) "desktop") ];
	targetPort = lib.net.getPort "ssh-net";
    };
}
