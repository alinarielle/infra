{lib, pkgs, config, ...}: 
with lib; with builtins;
{
    options.l.kernel.hardened.enable = mkEnableOption "hardened kernel";
    config = mkIf config.l.kernel.hardened.enable {
	boot.kernelParams = [
	    # Zero‐fill page and slab allocations
	    "init_on_free=1"

	    # Disable I/O delay
	    "io_delay=none"

	    # Enable page allocator free list randomisation
	    "page_alloc.shuffle=1"

	    # Disable slab merging
	    "slab_nomerge"

	    # Disable vsyscall mechanism
	    "vsyscall=none"
    
	    # Enable transparent hugepages
	    "transparent_hugepage=always"
	];

	boot.kernel.sysctl = {
	    # Mitigate some TOCTOU vulnerabilities
	    "fs.protected_fifos" = 2;
	    "fs.protected_hardlinks" = 1;
	    "fs.protected_regular" = 2;
	    "fs.protected_symlinks" = 1;

	    # Disable automatic loading of TTY line disciplines
	    "dev.tty.ldisc_autoload" = 0;

	    # Disable first 64 KiB of virtual memory for allocation
	    "vm.mmap_min_addr" = 65536;

	    # Increase ASLR randomisation
	    "vm.mmap_rnd_bits" = 32;
	    "vm.mmap_rnd_compat_bits" = 16;

	    # Restrict ptrace()
	    "kernel.yama.ptrace_scope" = 1;

	    # Hide kernel memory addresses
	    "kernel.kptr_restrict" = 2;

	    # Enable hardened eBPF JIT
	    "net.core.bpf_jit_enable" = 1;
	    "net.core.bpf_jit_harden" = 1;

	    # Ignore ICMP redirects
	    "net.ipv4.conf.default.accept_redirects" = 0;
	    "net.ipv6.conf.default.accept_redirects" = 0;
	    "net.ipv4.conf.all.accept_redirects" = 0;
	    "net.ipv6.conf.all.accept_redirects" = 0;

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
	    # default of 16 MiB should be sufficient to saturate 1GE
	    # maximum for 54 MiB sufficient for 10GE
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

	    # Dirty page cache ratio
	    "vm.dirty_background_ratio" = 3;
	    "vm.dirty_ratio" = 6;
	};

	boot.kernelPackages = let
	    kernel = pkgs.linux_latest;
	    llvm = pkgs.llvmPackages_latest;

	    version = pkgs.kernelPatches.hardened.${kernel.meta.branch}.version;
	    major = versions.major version;

	    sha256 = pkgs.kernelPatches.hardened.${kernel.meta.branch}.sha256;
	    modDirVer = replaceStrings [ kernel.version ] [ version ] kernel.modDirVersion;
	in mkDefault (pkgs.linuxPackagesFor (kernel.override {
	    # stdenv = llvm.stdenv;
	    extraMakeFlags = [ "LLVM=${llvm.bintools-unwrapped}/bin/" ];
	    kernelPatches = kernel.kernelPatches ++ [ pkgs.kernelPatches.hardened.${kernel.meta.branch} ];
	    modDirVersionArg = modDirVer + (pkgs.kernelPatches.hardened.${kernel.meta.branch}).extra + "-hardened1";
	    isHardened = true;
	    hardeningDisable = [ "strictoverflow" ];
	    #kernel.modDirVersion = pkgs.kernelPatches.hardened.${kernel.meta.branch}.version + "-hardened1";

	    argsOverride = {
		inherit version;
		src = pkgs.fetchurl {
		    url = "mirror://kernel/linux/kernel/v${major}.x/linux-${version}.tar.xz";
		    inherit sha256;
		};
	    };

	    structuredExtraConfig = with lib.kernel; {
		# Enable link‐time optimisation
		#LTO_CLANG_THIN = yes;

		# General memory hardening
		RESET_ATTACK_MITIGATION = yes;  # Request firmware to clear memory on reboot
		STRICT_KERNEL_RWX = yes;
		STRICT_MODULE_RWX = yes;

		# Stack hardening
		INIT_STACK_ALL_ZERO = yes;    # Zero‐initialise stack variables

		# Disable memory access interfaces
		STRICT_DEVMEM = option no;     # depends on DEVMEM
		IO_STRICT_DEVMEM = option no;  # depends on DEVMEM

		# Security modules
		SECURITY_SELINUX = no;   # Disable SELinux
		SECURITY_APPARMOR = mkForce no;  # Disable AppArmor
		DEFAULT_SECURITY_APPARMOR = mkForce (option no);

		# Permanently enable BPF JIT
		BPF_JIT_ALWAYS_ON = mkForce yes;

		# Replace menu governour with TEO
		CPU_IDLE_GOV_MENU = no;
		CPU_IDLE_GOV_TEO = yes;
		} // optionalAttrs pkgs.stdenv.hostPlatform.isx86_64 {
		X86_EXTENDED_PLATFORM = no;

		# Disable legacy x86 interfaces
		STRICT_SIGALTSTACK_SIZE = yes;
		LEGACY_VSYSCALL_XONLY = no;
		LEGACY_VSYSCALL_NONE = yes;

		# Disable I/O delay
		IO_DELAY_NONE = yes;
	    };
	  }));

	  systemd.tmpfiles.rules = [
	    "w- /sys/kernel/mm/transparent_hugepage/enabled - - - - always"
	    "w- /sys/kernel/mm/transparent_hugepage/defrag  - - - - defer+madvise"
	  ];
    };
}
