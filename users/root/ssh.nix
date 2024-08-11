{lib, config, ...}: lib.mkLocalModule ./. "root user ssh config" {
    users.users.root.openssh.authorizedKeys.keys = [
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINz9IXSb6I5uzk+tl4HAiBeCFwB+hD2owIvLyIirER/D alina"
    ];
}
