{pkgs, ...}:
{

imports = [
    ./shell.nix
];
environment.systemPackages = with pkgs; [
    neovim
    wget
];
users.users.alina.packages = with pkgs; [
    # fs tools
    du-dust
    lsd
    bat
    hexyl
    lsof
    ranger
    rsync
    rclone
    
    # archive tools
    p7zip
    zstd
    unzip
    unrar

    # networking
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

    # utils
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

    # monitoring
    btop
    htop

    # crypto
    pinentry
    gnupg

];
}
