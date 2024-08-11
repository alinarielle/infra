{lib, config, ...}: {
    options.l.meta.profiles.hardened.enable = lib.mkEnableOption "hardened profile";
    config = lib.mkIf config.l.meta.profiles.hardened.enable {
	l.kernel.hardened.enable = true;
	l.kernel.lsm.apparmor.enable = true;
	l.filesystem.hardened.enable = true;
	l.network.hardened.enable = true;
	l.packages.hardened.enable = true;
	
	environment.memoryAllocator.provider = "scudo";
	environment.variables.SCUDO_OPTIONS = "ZeroContents=1";

	security.lockKernelModules = true;

	security.protectKernelImage = true;

	security.allowSimultaneousMultithreading = mkDefault false;

	security.forcePageTableIsolation = true;

	# This is required by podman to run containers in rootless mode.
	security.unprivilegedUsernsClone = config.virtualisation.containers.enable;

	security.virtualisation.flushL1DataCache = "always";
    };
};
