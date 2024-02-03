{ lib, ...}:

{
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
	    shellGlobalAliases = {
		con = "ping 1.1 && ping archlinux.org";
		speed = "wget https://hel1-speed.hetzner.com/1GB.bin > /dev/zero";
		nv = "nvim";
		ls = "lsd";
		ll = "lsd -l";
		la = "lsd -a";
		laa = "lsd -all";
		cat = "bat";
		share = "curl -F 'f:1=<-' -s -o - ix.io";
		ip = "ip -c";
	    };
	};
	starship = {
	    enable = true;
	    settings = {
		add_newline = false;
		format = lib.concatStrings [
		    "$username"
		    "$hostname"
		    "$directory"
		    "$git_branch"
		    "$git_status" 
		    "$\{custom.direnv\}"
		    "$fill"
		    "$status"
		    "$cmd_duration"
		    "$line_break"
		    "$character"
		];
		username = {
		};
	    };
	};
    };
}
