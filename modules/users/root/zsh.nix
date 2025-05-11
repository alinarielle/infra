{ lib, pkgs, ... }: {
  programs.zsh.enable = true;
  home-manager.users.root.programs = {
    autojump.enable = true;
    carapace.enable = true;
    direnv.enable = true;
    fzf.enable = true;
    hstr.enable = true;
    navi.enable = true;
    yazi.enable = true;
    ripgrep.enable = true;
    bat.enable = true;
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
  environment.pathsToLink = ["/share/zsh" ];
  users.users.root.packages = with pkgs; [ zsh nix-your-shell ];
  users.users.root.shell = pkgs.zsh;
  home-manager.users.root.programs = {
    zsh = {
      enable = true;
      autocd = true;
      autosuggestion.enable = true;
      syntaxHighlighting = {
	enable = true;
	highlighters = ["main" "brackets" "pattern" "regexp" "cursor" "root" "line"];
      };
      history = {
	ignoreDups = false;
	extended = true;
	ignoreSpace = true;
      };
      initContent = ''
	if command -v nix-your-shell > /dev/null; then
	nix-your-shell zsh | source /dev/stdin
	fi
      '';
      shellGlobalAliases = {
	con = "ping 1.1 && ping archlinux.org";
	find = "find 2>/dev/null";
	speed = "wget https://hel1-speed.hetzner.com/1GB.bin; rm 1GB.bin";
	nv = "nvim";
	ls = "lsd";
	ll = "lsd -l";
	la = "lsd -a";
	laa = "lsd -all";
	cat = "bat";
	g = "git status";
	ip = "ip -c";
	md = "mdkir -p $1; cd $1";
	mv = "mv --interactive";
	hex = "hexyl";
	dns = "( nmcli dev list || nmcli dev show ) 2>/dev/null | grep DNS";
      };
    };
  };
}
