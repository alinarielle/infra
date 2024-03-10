{pkgs, ...}:
let
    editors = with pkgs; [
	neovim
	helix
	nano
    ];
    fstools = with pkgs; [
    	du-dust
    	lsd
    	bat
    	mdcat
    	hexyl
    	lsof
    	ranger
    	rsync
    	rclone
    ];
    archivetools = with pkgs; [	
    	p7zip
    	zstd
     	unzip
    	unrar
    ];
    networking = with pkgs; [
    	proxychains
    	tor
    	wireguard-tools
    	mullvad
    	mtr
    	nmap
    	netcat
    	sshfs
    	subfinder
    	tshark
    	w3m
    	dnsutils
    	ldns
    	dog
    	yt-dlp
    	yggdrasil
    	traceroute
    	lynx
    	elinks
	wget
	curl
    ];
    miscutils = with pkgs; [
	usbutils
    	appimage-run
    	tmate
	tmux
    	zellij
    	which
    	upower
    	ventoy
    	viu
    	doas
    	sdparm
    	nvme-cli
    	less
    	man-db
    	man-pages
    	lshw
    	pciutils
    	acpid
    	tlp
    	btrfs-progs
    	hdparm
    	strace
    	nix-output-monitor
	languagetool
	woeusb
	ffmpeg
    ];
    monitoring = with pkgs; [
	btop
	htop
    ];
    crypto = with pkgs; [
	pinentry
	gnupg
    ];
    devel = with pkgs; [
	gcc
	git
	checksec
	binwalk
	colmena
	apktool
	rustup
	chntpw
	fnm
    	rustup
    	sccache
    	radare2
    	android-tools
	gdb
    ];
    security = with pkgs; [
	checksec
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
in
{
    users.users.alina.packages = fstools ++ archivetools ++ networking ++ miscutils ++ monitoring ++ crypto ++ devel ++ security;
}
