{lib, config, pkgs, ...}: {
    imports = [ inputs.niri.nixosModules.niri ];
} // config.l.lib.mkLocalModule ./keybinds.nix "niri window manager keybindings" {
    programs.niri.settings.binds = let
	playerctl = ${lib.getExe pkgs.playerctl};
	kitty = ${lib.getExe pkgs.kitty};
	launcher = ${lib.getExe pkgs.sway-launcher-desktop}
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
	"Mod+D".action.spawn = [${kitty} ${launcher}];
        #${mod}.action.spawn = [ ];
    };
};
