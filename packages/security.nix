{lib, config, pkgs, ...}: config.l.lib.mkLocalModule ./security "security pkgs" {
    users.users.alina.packages = with pkgs; [
	checksec
	mitmproxy
	mitmproxy2swagger
	websploit
	bettercap
	cantoolz
	ssh-mitm
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
