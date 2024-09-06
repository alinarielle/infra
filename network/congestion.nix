{lib, config, ...}: config.l.lib.mkLocalModule 
    ./congestion.nix 
    "set default congestion control algorithm" 
{
    boot.kernel.sysctl = lib.mkDefault {
	"net.ipv4.tcp_congestion_control" = "bbr";
    };
}
