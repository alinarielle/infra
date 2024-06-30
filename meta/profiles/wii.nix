{pkgs, lib, config, microvm, ...}: 
let
    cfg = config.options.profiles.wii;
in
{
    options.profiles.wii = {
	enable = lib.mkOption {
	    type = lib.types.bool;
	    default = false;
	    description = lib.mdDoc ''
		This option enables the Wii profile.
		A Mullvad account token needs to be set for this profile to work.
		This behavior can be overriden by enabling ${cfg}.mullvad.override.
	    ''
	};
	mullvad.token = lib.mkOption {
	    type = lib.types.str;
	    example = "34897269739647635";
	    description = lib.mdDoc ''
		This option sets the Mullvad account token.
		If this option is set, the Mullvad VPN will be activated.
	    '';
	};
	mullvad.override = lib.mkOption {
	    type = lib.types.bool;
	    example = false;
	    description = lib.mdDoc ''
		This option allows you to proceed without mullvad if set to true.
		Use at your own risk!
	    '';
	};
	mullvad.exitNode = lib.mkOption {
	    type = lib.types.str;
	    example = ""; #TODO
	    description = lib.mdDoc ''
		This option specifies the Mullvad exit node to use.
	    '';
	};
	devices = lib.mkOption {
	    type = lib.types.listOf str;
	    example = ""; #TODO
	    description = lib.mdDoc ''
		This option specifies a list of devices to be made available to the VM for use in the Wii Emulator.
	    '';
	};
	games = lib.mkOption {
	    type = lib.types.listOf str;
	    example = [
		"New Super Mario Bros"
		"Super Mario Galaxy 2"
	    ];
	    description = lib.mdDoc ''
		This option installs every game in the list, given it can parse and find it.
		A zip with a .rvz inside is expected.
		Download them from https://myrient.erista.me/
	    '';
	};
	dir = lib.mkOption {
	    type = lib.types.str;
	    example = "/var/wii";
	    default = "/home/wii";
	    description = lib.mdDoc ''
		This option sets the working and data directory of the Wii.
	    '';
	};
	saves = {
	    enable = lib.mkOption {
		type = lib.types.bool;
		example = true;
		default = false;
		description = lib.mdDoc ''
		    This option enables saving game save states.
		'';
	    };
	    where = lib.mkOption {
		type = lib.types.str;
		example = "scp://alina@example.com:gameSaves";
		description = lib.mdDoc ''
		    Which URI to save the save files to.
		    Available protocols are:
			- restic
			- scp
			- syncthing
			- rsync
			- just moving it to a certain folder in the same filesystem
		'';
	    };
	};
    };
    imports = [
	microvm.host
	microvm.nixosModules.host
	home-manager.nixosModules.home-manager
    ];
    config = lib.mkIf cfg.enable {
	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true;
	microvm.vms.wii = {
	    inherit pkgs;
	};
	microvm.vms.wii.config = {
	    microvm.shares = [{
		source = "/nix/store";
		mountPoint = "/nix/.ro-store";
		tag = "ro-store";
		proto = "virtiofs";
	    }];
	    microvm.devices = cfg.devices;
	    inherit hardware.bluetooth.enable hardware.bluetooth.powerOnBoot home-manager;
	    fonts.packages = pkgs.nerdfonts;
	    services.mullvad-vpn.enable = lib.mkIf (builtins.match ^\d+$ cfg.mullvad.token) true; # if token value is numerical without any spaces activate mullvad
	    environment.systemPackages = with pkgs; [
		cage
		qt5.qtwayland
		waypipe
		wl-clipboard
		wlprop
		wev
		wf-recorder
		grimblast
		eww-wayland
		wofi
		mako
		dolphin-emu
		p7zip
		wget
		${lib.mkIf (builtins.match ^\d+$ cfg.mullvad.token) mullvad}
	    ];
	    environment.sessionVariables = {
		SDL_VIDEODRIVER = "wayland";
		QT_QPA_PLATFORM = "wayland";
		QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
		NIXOS_OZONE_WL = "1";
	    };
	    sound.enable = true;
	    security.rtkit.enable = true;
	    services.pipewire = {
		enable = true;
		audio.enable = true;
	    };
	    services.cage = {
		enable = true;
		program = wii launch script; #TODO
		user = "wii";
		extraArguments = [
		    "-d" # don't draw client side decorations, when possible
		    "-m last" # use only the last connected output
		    "-s" # allow VT switching
		];
	    };
	    systemd.tmpfiles.settings = {
		"wii-folder" = {
		    "${cfg.dir}" = {
			d = {
			    group = "wii";
			    user = "wii";
			    mode = "770"; #full perms for owner and group, no perms for public
			    age = "-";
			};
		    };
		};
	    };
	    services.mullvad-vpn.enable = lib.mkIf cfg.mullvad.token true;
	    assertions = [{
		assertion = !(builtins.match ^\d+$ cfg.mullvad.token) && cfg.mullvad.override;
		message  = "Mullvad account token is not set or not a valid token! Cannot proceed without Mullvad. Set ${cfg}.mullvad.override to proceed without mullvad."
	    }];
	    systemd.services.wii-games = {
		description = "install Wii games";
		wantedBy = [ "networking.target" ];
		serviceConfig = {
		    Type = "oneshot";
		    User = "wii";
		};
		script = ''
		    set -eou pipefail
		    cd ${cfg.dir}
		    mkdir -p games
		    cd games
		    download () {
			wget $1 -O game.zip
			7z e game.zip
			rm game.zip
		    } 
		    ${lib.concatMapStringsSep "\n" (x: "download " + x) cfg.games}
		'';
	    };
	    network.useNetworkd = true;
	    systemd.network.enable = true;
	};
	# TODO
	#networking
	#eww & rofi ui & config w/ dynamic themeing
	#dolphin config
	#kill switch
	#improve gpu passthrough, make it less effort
	#write launch script
	#fill missing option examples
    };
}
