{ lib, pkgs, ...}:
{
users.users.alina.shell = pkgs.zsh;
programs.zsh.enable = true;
environment.pathsToLink = ["/share/zsh" ];

environment.systemPackages = with pkgs; [ nix-your-shell ];

users.users.alina.packages = with pkgs; [ zsh nushell ];
home-manager.users.alina = {
    programs = {
        autojump.enable = true;
	carapace.enable = true;
	direnv.enable = true;
	fzf.enable = true;
	hstr.enable = true;
	navi.enable = true;
	yazi.enable = true;
	bat.enable = true;
	ripgrep.enable = true;
	zsh = {
	    enable = true;
	    autocd = true;
	    enableAutosuggestions = true;
	    syntaxHighlighting = {
		enable = true;
		highlighters = ["main" "brackets" "pattern" "regexp" "cursor" "root" "line"];
	    };
	    history = {
		ignoreDups = false;
		extended = true;
		ignoreSpace = true;
	    };
	    initExtra = ''
		if command -v nix-your-shell > /dev/null; then
  		  nix-your-shell zsh | source /dev/stdin
		fi
		[ "$(tty)" = "/dev/tty1" ] && exec "sway"
	    '';
	    shellGlobalAliases = {
		con = "ping 1.1 && ping archlinux.org";
		speed = "wget https://hel1-speed.hetzner.com/1GB.bin > /dev/zero";
		nv = "nvim";
		ls = "lsd";
		ll = "lsd -l";
		la = "lsd -a";
		laa = "lsd -all";
		cat = "bat";
		#share = "curl -F 'f:1=<-' -s -o - ix.io"; ix.io went out of business, replace with own pastebin later TODO
		ip = "ip -c";
	    };
	};
	starship = {
	    enable = true;
	    settings = {
		add_newline = false;
		format = lib.concatStrings [
		    "$username"
		    "$os"
		    "$all"
		];
		username = {
		    show_always = true;
		    format = "[$user]($style)::";
		    style_root = "bold red";
		    style_user = "bold cyan";
		};
		os = {
		    disabled = false;
		    style = "bold cyan";
		    format = " ($style)";
		};
		sudo.disabled = false;
	    };
	};
    };
};
}
