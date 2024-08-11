{lib, config, pkgs, ...}: lib.mkLocalModule ./. "security related packages" {
    users.users.alina.packages = with pkgs; [
	checksec
	frida-tools
	apktool
	binwalk
	thc-hydra
	john
	metasploit
	sherlock
	radare2
	sslsplit
	subfinder
	seclists
    ];
}
