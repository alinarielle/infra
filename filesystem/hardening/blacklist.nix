{lib, config, ...}: config.l.lib.mkLocalModule ./blacklist.nix "disabled filesystems" {
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
}
