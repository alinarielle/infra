{lib, config, pkgs, ...}: config.l.lib.mkLocalModule ./security "security pkgs" {
    users.users.alina.packages = with pkgs; [
	checksec
	jd-cli
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
