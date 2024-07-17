{lib, config, ...}:
{
    options.l.network.rnat = {
	enable = lib.mkEnableOption "rnat";
    };
    config = {
	system.environmentPackages = [ inputs.rnat.packages.default ];
	
    };
}
