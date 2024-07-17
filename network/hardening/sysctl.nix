{lib, config, ...}: {
    options.l.network.hardening.sysctl.enable = lib.mkEnableOption "sysctl net config";
    config = lib.mkIf config.network.hardening.sysctl.enable {
	boot.kernel.sysctl = with lib; {
	    # Ignore incoming ICMP redirects (note: default is needed to ensure that the
	    # setting is applied to interfaces added after the sysctls are set)
	    "net.ipv4.conf.all.accept_redirects" = mkDefault false;
	    "net.ipv4.conf.all.secure_redirects" = mkDefault false;
	    "net.ipv4.conf.default.accept_redirects" = mkDefault false;
	    "net.ipv4.conf.default.secure_redirects" = mkDefault false;
	    "net.ipv6.conf.all.accept_redirects" = mkDefault false;
	    "net.ipv6.conf.default.accept_redirects" = mkDefault false;

	    # Ignore outgoing ICMP redirects (this is ipv4 only)
	    "net.ipv4.conf.all.send_redirects" = mkDefault false;
	    "net.ipv4.conf.default.send_redirects" = mkDefault false;

	    # Enable strict reverse path filtering (that is, do not attempt to route
	    # packets that "obviously" do not belong to the iface's network; dropped
	    # packets are logged as martians).
	    "net.ipv4.conf.all.log_martians" = mkDefault true;
	    "net.ipv4.conf.all.rp_filter" = mkDefault "1";
	    "net.ipv4.conf.default.log_martians" = mkDefault true;
	    "net.ipv4.conf.default.rp_filter" = mkDefault "1";

	    # Ignore broadcast ICMP (mitigate SMURF)
	    "net.ipv4.icmp_echo_ignore_broadcasts" = mkDefault true;

	    # Set default Qdisc
	    "net.core.default_qdisc" = "cake";

	    # Increase minimum PMTU
	    "net.ipv4.min_pmtu" = 1280;

	    # Set default TCP congestion control algorithm
	    "net.ipv4.tcp_congestion_control" = "bbr";

	    # Enable ECN
	    "net.ipv4.tcp_ecn" = 1;

	    # Enable TCP fast open
	    "net.ipv4.tcp_fastopen" = 3;

	    # Disable TCP slow start after idling
	   "net.ipv4.tcp_slow_start_after_idle" = 0;

	    # Allow re‐use of TCP ports during TIME-WAIT
	    "net.ipv4.tcp_tw_reuse" = 1;

	    # Enable TCP MTU probing
	    "net.ipv4.tcp_mtu_probing" = 1;
	    "net.ipv4.tcp_mtu_probe_floor" = 1220;

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

	    # Reduce TCP keep‐alive time‐out to 2 minutes
	    "net.ipv4.tcp_keepalive_time" = 60;
	    "net.ipv4.tcp_keepalive_probes" = 6;
	    "net.ipv4.tcp_keepalive_intvl" = 10;

	    # Widen local port range
	    "net.ipv4.ip_local_port_range" = "16384 65535";

	    # Increase default MTU
	    "net.ipv6.conf.default.mtu" = 1452;
	    "net.ipv6.conf.all.mtu" = 1452;

	    # Set traffic class for NDP to CS6 (network control)
	    "net.ipv6.conf.default.ndisc_tclass" = 192;
	    "net.ipv6.conf.all.ndisc_tclass" = 192;
	};
    };
}
