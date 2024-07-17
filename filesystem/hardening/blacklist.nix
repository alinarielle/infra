{lib, config, ...}: {
    options.l.filesystem.hardening.blacklist.enable = 
	lib.mkEnableOption "black listed filesystems";
    config = lib.mkIf config.l.filesystem.hardening.blacklist.enable {
	boot.blacklistedKernelModules = [
	# disabling old or rare or insufficiently audited filesystems for security reasons
	    "adfs"
	    "affs"
	    "bfs"
	    "befs"
	    "cramfs"
	    "efs"
	    "erofs"
	    "exofs"
	    "freevxfs"
	    "f2fs"
	    "hfs"
	    "hpfs"
	    "jfs"
	    "minix"
	    "nilfs2"
	    "ntfs"
	    "omfs"
	    "qnx4"
	    "qnx6"
	    "sysv"
	    "ufs"
	  ];
    };
}
