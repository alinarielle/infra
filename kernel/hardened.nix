{lib, pkgs, config, ...}: {
    options.l.kernel.hardened.enable = lib.mkEnableOption "hardened kernel";
    config = mkIf config.l.kernel.hardened.enable 
	let ifApparmor = config.l.kernel.lsm.apparmor.enable; in {
	boot.kernelPackages = let
	    kernel = pkgs.linux-libre;
	    llvm = pkgs.llvmPackages_latest;

	    version = pkgs.kernelPatches.hardened${kernel.meta.branch}.version;
	    major = lib.versions.major version;

	    sha256 = pkgs.kernelPatches.hardened.${kernel.meta.branch}.sha256;
	    modDirVer = lib.replaceStrings 
		[ kernel.version ] 
		[ version ] 
		kernel.modDirVersion;
	    in lib.mkDefault (pkgs.linuxPackagesFor (kernel.override {
		stdenv = llvm.stdenv;
		extraMakeFlags = [ "LLVM=${llvm.bintools-unwrapped}/bin/" ];
		kernelPatches = kernel.kernelPatches 
		    ++ [ pkgs.kernelPatches.hardened.${kernel.meta.branch} ];
		modDirVersionArg = 
		    modDirVer + 
		    (pkgs.kernelPatches.hardened.${kernel.meta.branch}).extra;
		isHardened = true;
		argsOverride = {
		    inherit version;
		    src = pkgs.fetchurl {
			url = 
		    "mirror://kernel/linux/kernel/v${major}.x/linux-${version}.tar.xz";
			inherit sha256;
		    };
		};
		structuredExtraConfig = with lib.kernel; {
		    # report BUG() conditions and kill the offending process
		    BUG = yes;
		    
		    # safer page access permissions to prevent code injection
		    DEBUG_RODATA = yes;
		    SET_MODULE_RONX = yes;

		    # validation of commonly targeted structures
		    DEBUG_CREDENTIALS = yes;
		    DEBUG_NOTIFIERS = yes;
		    DEBUG_PLIST = yes;
		    DEBUG_SG = yes;
		    SCHED_STACK_END_CHECK = yes;

		    # randomize page allocator when page_alloc.shuffle=1
		    SHUFFLE_PAGE_ALLOCATOR = yes;
		    
		    # allow enabling slub/slab free poisoning with slub_debug=P
		    SLUB_DEBUG = yes;

		    # wipe higher-level memory allocations on free() with page_poison=1
		    PAGE_POISONING = yes;
		    PAGE_POISONING_NO_SANITY = yes;
		    PAGE_POISONING_ZERO = yes;
		    

		    # reboot devices immediately when the kernel panics
		    PANIC_TIMEOUT = freeform "-1";


		    ## GCC options (i use LLVM btw) ##

		    # GCC_PLUGINS = yes; # Enable gcc plugin options	    
		    # Gather additional entropy at boot time for systems that may not 
		    # have appropriate entropy sources.
		    # GCC_PLUGIN_LATENT_ENTROPY = yes;
		    # GCC_PLUGIN_STRUCTLEAK = yes; # A port of the PaX structleak plugin
		    # GCC_PLUGIN_STRUCTLEAK_BYREF_ALL = yes; # also cover structs passed by address
		    # GCC_PLUGIN_STACKLEAK = yes; # A port of the PaX stackleak plugin
		    # GCC_PLUGIN_RANDSTRUCT = yes; # A port of the PaX randstruct plugin
		    # GCC_PLUGIN_RANDSTRUCT_PERFORMANCE = yes;

		    # enable link-time optimisation
		    LTO_CLANG_THIN = yes;

		    # clear memory at reboot via EFI
		    # https://trustedcomputinggroup.org/resource/pc-client-work-group-platform-reset-attack-mitigation-specification/
		    # https://bugzilla.redhat.com/show_bug.cgi?id=1532058
		    RESET_ATTACK_MITIGATION = yes;

		    # kernel memory permission enforcement
		    STRICT_KERNEL_RWX = yes;
		    STRICT_MODULE_RWX = yes;
		    VMAP_STACK = yes;

		    # kernel image and memory ASLR
		    RANDOMIZE_BASE = yes;
		    RANDOMIZE_MEMORY = yes;

		    # randomize allocator freelists, harden metadata
		    SLAB_FREELIST_RANDOM = yes;
		    SLAB_FREELIST_HARDENED = yes;
		    SHUFFLE_PAGE_ALLOCATOR = yes;
		    RANDOM_KMALLOC_CACHES = yes;

		    # sanity check userspace page table mappings
		    PAGE_TABLE_CHECK = yes;
		    PAGE_TABLE_CHECK_ENFORCED = yes;

		    # randomize kernel stack offset on syscall entry
		    RANDOMIZE_KSTACK_OFFSET_DEFAULT = yes;

		    # stack frame overflow protection
		    STACKPROTECTOR = yes;
		    STACKPROTECTOR_STRONG = yes;

		    # buffer length bounds checking
		    HARDENED_USERCOPY = yes;
		    FORTIFY_SOURCE = yes;

		    # array index bounds checking
		    UBSAN = yes;
		    UBSAN_TRAP = yes;
		    UBSAN_BOUNDS = yes;
		    UBSAN_ALIGNMENT = yes;
		    ## unaligned memory access is bad and evil!!
		    ## sanitizing this will cause lots of reports and warnings though
		    ## it works on x86 though i think
		    UBSAN_SHIFT = unset;
		    UBSAN_DIV_ZERO = unset;
		    UBSAN_UNREACHABLE = unset;
		    UBSAN_SIGNED_WRAP = unset;
		    UBSAN_BOOL = unset;
		    UBSAN_ENUM = unset;
		    
		    # sampling-based heap out-of-bounds and user-after-free detection
		    KFENCE = yes;

		    # linked list integrity checking
		    LIST_HARDENED = yes;
		    
		    # zero-initialise heap variables on allocation
		    INIT_ON_ALLOC_DEFAULT =yes;

		    # zero-initialise stack variables on function entry
		    INIT_STACK_ALL_ZERO = yes;
		    
		    # disable DMA between EFI hand-off and the kernel's IOMMU setup
		    EFI_DISABLE_PCI_DMA = yes;

		    # force IOMMU TLB invalidation so devices will never be able to
		    # access stale data content
		    IOMMU_SUPPORT = yes;
		    IOMMU_DEFAULT_DMA_STRICT = yes;

		    # do not allow direct physical memory access to non-device memory
		    STRICT_DEVMEM = option no;		# depends on DEVMEM
		    IO_STRICT_DEVMEM = option no; 	# depends on DEVMEM

		    # provide userspace with seccomp BPF API
		    # for syscall attack surface reduction
		    SECCOMP = yes;
		    SECCOMP_FILTER = yes;

		    # provides some protections against SYN flooding
		    SYN_COOKIES = yes;

		    # enable kernel control flow integrity (currently Clang only)
		    CFI_CLANG = yes;
		    # CFI_PERMISSIVE

		    # attack surface reduction; do not autoload TTY line disciplines
		    LDISC_AUTOLOAD = no;

		    # dangerous; enabling this disables userpace brk ASLR
		    COMPAT_BRK = no;

		    # dangerous; exposes kernel text image layout
		    PROC_KCORE = no;

		    # dangerous; enabling this disables userspace VDSO ASLR
		    COMPAT_VDSO = no;

		    # attack surface reduction: use modern PTY interface (devpts) only
		    LEGACY_PTYS = no;

		    # dangerous; allows writing directly to physical memory
		    ACPI_CUSTOM_METHOD = no;

		    # attack surface reduction; has been used for heap based attacks
		    INET_DIAG = no;

		    # Security modules
		    SECURITY_SELINUX = yes;
		    SECURITY_APPARMOR = yes;
		    SECURITY_SAFESETID = yes;
		    DEFAULT_SECURITY_APPARMOR = lib.mkIf ifApparmor yes;
		    DEFAULT_SECURITY = lib.mkIf ifApparmor (freeform "apparmor");
		    SECURITY_APPARMOR_BOOTPARAM_VALUE = lib.mkIf ifApparmor (freeform "1";)

		    # mark LSM hooks read-only after init
		    SECURITY_WRITABLE_HOOKS = no;

		    # enable BPF; may expose kernel to spray attacks though
		    BPF_JIT_ALWAYS_ON = yes;

		    # Replace menu governour with TEO
		    CPU_IDLE_GOV_MENU = no;
		    CPU_IDLE_GOV_TEO = yes;
		} // lib.optionalAttrs pkgs.stdenv.hostPlatform.isx86_64 {
		    X86_EXTENDED_PLATFORM = no;

		    # don't sanitize unaligned memory access resulting in 
		    # undefined behavior because x86 supports unalligned access
		    UBSAN_ALIGNMENT = no;

		    # enable chip-specific IOMMU support
		    INTEL_IOMMU = yes;
		    INTEL_IOMMU_DEFAULT_ON = yes;
		    INTEL_IOMMU_SVM = yes;
		    AMD_IOMMU = yes;
		    
		    # enforce CET Indirect Branch Tracking in the kernel
		    X86_KERNEL_IBT = yes;

		    # enable CET shadow stack for userspace
		    X86_USER_SHADOW_STACK = yes;

		    # disable legacy x86 interfaces
		    STRICT_SIGALTSTACK_SIZE = yes;
		    LEGACY_VSYSCALL_XONLY = no;

		    # modern libc no longer needs a fixed-position mapping in userspace,
		    # remove it as a possible target
		    LEGACY_VSYSCALL_NONE = yes;

		    # disable IO delay
		    IO_DELAY_NONE = yes;
		};
	    }))
	boot.kernelParams = [
	    # set apparmor as the default security module
	    (lib.mkIf ifApparmor "security=apparmor")

	    # zero-fill page and slab allocations
	    "init_on_free=1"

	    # disable IO delay
	    "io_delay=none"

	    # enable page allocator free list randomization
	    "page_alloc.shuffle=1"

	    # overwrite free()'d pages
	    "page_poison=1"

	    # disable slab merging
	    "slab_nomerge"

	    # disable vsyscall mechanism
	    "vsyscall=none"

	    # enable transparent hugepages
	    "transparent_hugepage=always"

	    # disable debugfs
	    "debugfs=off"

	    # clear mlocked memory in case the program crashes
	    "init_mlocked_on_free=1"
	];
	boot.kernel.sysctl = {
	    # disable automatic loading of TTY line disciplines
	    "dev.tty.ldisc_autoload" = 0;

	    "kernel.ftrace_enabled" = lib.mkDefault false;

	    # disable first 64 KiB of virtual memory for allocation
	    "vm.mmap_min_addr" = 65536;

	    # increase ASLR randomisation
	    "vm.mmap_rnd_bits" = 32;
	    "vm.mmap_rnd_compat_bits" = 16;

	    # restrict ptrace()
	    "kernel.yama.ptrace_scope" = 1;

	    # hide kernel memory addresses
	    "kernel.kptr_restrict" = 2;

	    # enable hardened eBPF JIT
	    "net.core.bpf_jit_enable" = 1;
	    "net.core.bpf_jit_harden" = 1;

	    # Dirty page cache ratio
	    "vm.dirty_background_ratio" = 3;
	    "vm.dirty_ratio" = 6;

	    # Hide kptrs even for processes with CAP_SYSLOG
	    "kernel.kptr_restrict" = lib.mkOverride 500 2;
	};

    };
}
# references: 
# - https://github.com/NixOS/nixpkgs/blob/e6db435973160591fe7348876a5567c729495175/pkgs/os-specific/linux/kernel/hardened/config.nix
# - https://nixos.wiki/wiki/Linux_kernel#Custom_configuration
# - https://kspp.github.io/
# - linux src/arch/x86/configs/hardening.config and src/kernel/configs/hardening.config
# - trial and error
# - illdef
