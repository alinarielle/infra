{lib, pkgs, self, ...}: self.lib.modules.mkLocalModule ./documents.nix "document editing shortcuts" {
    home-manager.users.alina.programs = {
	kitty.settings.keybindings."shift+ctrl+d" = let
	swaymsg = "${pkgs.sway}/bin/swaymsg";
	typst = lib.getExe pkgs.typst;
	zathura = lib.getExe pkgs.zathura; 
	common = "launch --title=current --cwd=current --type=background --env window_title=$(${swaymsg} -t get_tree | jq -r '..|try select(.focused == true).name') echo $(window_title##*' ') :"; in 
	    "combine : new_window+with_cwd : goto_layout tall:bias=20;full_size=2;mirrored=false : ${common} --type=background --cwd=current --dont-take-focus --stdin-source@last_cmd_output read -r document && ${zathura} --fork $(document/typ/pdf) : ${common} launch --cwd=current --location=after --hold --dont-take-focus --stdin-source@last_cmd_output read -r document && ${typst} watch $document";
    };
}
