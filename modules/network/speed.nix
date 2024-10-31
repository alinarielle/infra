{
    boot.kernel.sysctl = {
	# Increase socket buffer space
	#  default of 16 MiB should be sufficient to saturate 1GE
	#  maximum for 54 MiB sufficient for 10GE
	"net.core.rmem_default" = 16777216;
	"net.core.rmem_max" = 56623104;
	"net.core.wmem_default" = 16777216;
	"net.core.wmem_max" = 56623104;
	"net.core.optmem_max" = 65536;
	"net.ipv4.tcp_rmem" = "4096 1048576 56623104";
	"net.ipv4.tcp_wmem" = "4096 65536 56623104";
	"net.ipv4.tcp_notsent_lowat" = 16384;
	"net.ipv4.udp_rmem_min" = 9216;
	"net.ipv4.udp_wmem_min" = 9216;
    };
}
