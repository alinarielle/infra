{lib, config, pkgs, name, inputs, ...}: {
    imports = [ inputs.niri.nixosModules.niri ]; 
} // config.l.lib.mkLocalModule ./niri.nix "niri window manager general config" {
	programs.niri = {
	    enable = true;
	    niri-flake.cache.enable = true;
	    settings = {
		screenshot-path = 
		    "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
		hotkey-overlay.skip-at-startup = false;
		spawn-at-startup = {
		    mon = {
			command = 
			    "${lib.getExe pkgs.kitty} --hold ${lib.getExe pkgs.bottom}";
		    };
		};
		input = {
		    focus-follows-mouse = true;
		    mouse = { 
			natural-scroll = true;
		    };
		    keyboard = {
			options = "compose:ralt";
		    };
		    power-key-handling.enable = false;
		    tablet.enable = false;
		    touchpad = {
			click-method = "button-areas";
			accel-profile = "flat";
			dwt = false;
			dwtp = false;
			natural-scroll = true;
			scroll-method = "two-fingers";
			tap = true;
		    };
		    trackpoint.enable = lib.mkIf (name == "lilium") false;
		};
		layout = {
		    border = {
			enable = true;
			width = 2;
			active = {
			    color = "#${config.colorScheme.palette.blue}";
			};
			inactive = {
			    color = "#${config.colorScheme.palette.dark}";
			};
		    };
		    gaps = 10;
		    struts = {
			bottom = 10;
			top = 10;
			left = 10;
			right = 10;
		    };
		};
		animations = {
		    enable = true;
		    slowdown = 1;
		};
		environment = {
		    SDL_VIDEODRIVER = "wayland";
		    QT_QPA_PLATFORM = "wayland";
		    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
		    _JAVA_AWT_WM_NONPARENTING = "1";
		    NIXOS_OZONE_WL = "1";
		};
	    };
	};
    };
}
