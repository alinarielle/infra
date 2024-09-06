{lib, config, pkgs, ...}: with config.l.lib; mkLocalModule ./base.nix "base profile" {
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
	"desktop"
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
