{lib, config, pkgs, ...}: with lib.meta; lib.mkLocalModule ./. "base profile" {
    l.filesystem = enable ["zram"];
    l.boot = enable ["systemd-boot"];
    l.deployment = enable ["colmena"];
    l.users = enable ["root" "alina"];
    l.packages = enable [
	"base" 
	"archivetools" 
	"fstools" 
	"chat" 
	"networking" 
	"misc"
	"crypto" 
	"devel" 
	"security"
    ];
    l.network = enable [
	"speed" 
	"bbr" 
	"networkmanager"
	"congestion"
	"time"
	"hostName"
	"domain"
	#"ssh-net"
    ];
}
