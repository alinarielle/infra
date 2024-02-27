{pkgs, ...}:
{
## home manager stuff
home-manager.useGlobalPkgs = true;
home-manager.useUserPackages = true;
home-manager.users.alina = {
    home.username = "alina";
    home.homeDirectory = "/home/alina";
    home.stateVersion = "23.11"; # To figure this out you can comment out the line and see what version it expected.
    programs.home-manager.enable = true;
};


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
    mdcat
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
