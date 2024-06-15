{lib, config,...}:
with lib; with builtins;
{
    options.profiles.desktop.niri = mkEnableOption "niri";
    config = {
	programs.niri = {
	    enable = true;
	    niri-flake.cache.enable = true;
	    settings = {
		binds = let
		    playerctl = ${getExe pkgs.playerctl};
		    mod = "Mod4"; #FIXME
		in {
		    "XF86AudioRaiseVolume".action.spawn = 
			["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"];
		    "XF86AudioLowerVolume".action.spawn = 
			["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
		    "XF86AudioMute".action.spawn =
			["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK" "toggle"];
		    "XF86AudioPlay".action.spawn = [${playerctl} "play-pause"];
		    "XF86AudioNext".action.spawn = [${playerctl} "next"];
		    "XF86AudioPrev".action.spawn = [${playerctl} "previous"];
		    #${mod}.action.spawn = [ ];
		};
	    };
	};
    };
}
