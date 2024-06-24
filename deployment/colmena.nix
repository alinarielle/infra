{lib, config, ...}:
with lib; with builtins;
{
    deployment = mkDefault {
	targetUser = "alina";
	allowLocalDeployment = mkIf (elem "desktop" config.deployment.tags) true;
	tags = [ "infra" ];
	targetPort = head config.openssh.ports;
    };
}
