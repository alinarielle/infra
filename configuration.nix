# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # enable automatic garbage collection
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # activate exerimental features
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # enable native wayyland support for chrome and electron
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # zsh completion
  environment.pathsToLink = [ "/share/zsh" ];

  # define a systemd service for ly
  systemd.services.ly = {
    description = "TUI display manager";

  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices.main.device = "/dev/disk/by-uuid/e1743e69-f6f7-4497-895f-7b5bc2fa5ef0";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "snd-intel-dspcfg.dsp_driver=1"];
  boot.extraModprobeConfig = ''
  options snd-intel-dspcfg dsp_driver=1
'';
  # enable bluetooth
  hardware.bluetooth.enable = false;
  hardware.bluetooth.powerOnBoot = false;

  networking.hostName = "lilium"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # audio
  sound.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    audio.enable = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;
  programs.sway.enable = true;
  programs.steam.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.alina = {
     isNormalUser = true;
     shell = pkgs.zsh;
     extraGroups = [ 
     "wheel"
     "networkmanager"
     ];
     packages = with pkgs; [
       mpv
       pavucontrol
       proxychains
       alsa-ucm-conf
       sof-firmware
       pciutils
       spotify
       usbutils
       mpvpaper
       gcc
       gnupg
       pinentry
       pinentry-qt
       swayfx
       tor-browser
       krita
       librewolf
       ly
       exif
       alsa-utils
       sway-launcher-desktop
       git
       element-desktop
       colmena
       nerdfonts
       wl-clipboard
       pango
       fontconfig
       bluez
       android-tools
       gomuks
       avahi
       binwalk
       tlp
       acpid
       android-file-transfer
       wofi
       swaybg
       kitty
       waybar
       swaylock
       cargo
       zsh
       hyfetch
       checksec
       apktool
       chntpw
       thc-hydra
       john
       powertop
       btop
       htop
       lsd
       bat
       nushell
       lynx
       elinks
       btrfs-progs
       ffmpeg
       mako
       feh
       sway-contrib.grimshot
       gamemode
       proxychains
       tor
       hdparm
       hexyl
       hollywood
       imagemagick
       keepassxc
       jq
       jdk21
       jdk17
       jdk8
       less
       languagetool
       lshw
       lsof
       man-db
       man-pages
       metasploit
       monero
       mullvad
       wireguard-tools
       nethack
       mtr
       nvme-cli
       nodejs
       fnm
       noisetorch
       nmap
       netcat
       pferd
       playerctl
       eww
       plymouth
       prismlauncher
       qbittorrent
       radare2
       ranger
       rsync
       rustup
       sccache
       sdparm
       sherlock
       signal-desktop
       sshfs
       sslsplit
       standardnotes
       starship
       strace
       subfinder
       doas
       tcpdump
       tdrop
       telegram-desktop
       termshark
       tshark
       wireshark
       thunderbird
       thefuck
       tmux
       tmate
       zellij
       traceroute
       ungoogled-chromium
       upower
       ventoy
       virt-manager
       viu
       w3m
       which
       dog
       wfuzz
       wireplumber
       woeusb
       yt-dlp
       yggdrasil
       zathura
     ];
   };
   fonts.packages = with pkgs; [
	nerdfonts
   ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    swaylock
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

