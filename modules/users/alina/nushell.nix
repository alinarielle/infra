{pkgs, lib, config, name, ...}: {
  #users.users.alina.packages = with pkgs; [nix-your-shell];
  #home.file.".config/nushell/nix-your-shell.nu".source = 
    #pkgs.nix-your-shell.generate-config "nu";
  users.users.alina.shell = pkgs.nushell;
  environment.systemPackages = with pkgs.nushellPlugins; [
    net
    skim
    dbus
    units
    query
    gstat
  ];
  home-manager.users.alina.programs = {
    nushell = {
      enable = true;
      configFile.text = ''
	#source nix-your-shell.nu
	$env.config.buffer_editor = ["emacsclient", "-s", "light", "-t"]
      '';
      shellAliases = {
	nv = "nvim";
	cat = "bat -p";
	ip = "ip -c";
	g = "git status";
	mv = "mv --interactive";
	l = "lsd";
	ll = "lsd -l";
	la = "lsd -a";
	laa = "lsd -all";
	update = "cd ~/src/flake; nix flake update; zsh -c 'sudo nixos-rebuild switch --flake ~/src/flake#${name} --log-format internal-json -v |& nom --json'";
      };
    };
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
	  "$username" "$os" "$all"
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
}
