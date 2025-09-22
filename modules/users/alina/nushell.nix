{
  pkgs,
  lib,
  config,
  name,
  ...
}:
{
  environment.systemPackages = with pkgs.nushellPlugins; [
    skim
    #dbus
    #units
    query
    gstat
    pkgs.nushell
  ];
  home-manager.users.alina.xdg.configFile = {
    "nix-your-shell.nu".source = pkgs.nix-your-shell.generate-config "nu";
  };

  home-manager.users.alina.programs = {
    zoxide = {
      enable = true;
      enableNushellIntegration = true;
      options = [
        "--cmd j"
        "--hook prompt"
      ];
    };
    nushell = {
      enable = true;
      configFile.text = ''
        	      $env.EDITOR = "nvim"
      '';
      settings = {
        color_config =
          with config.l.desktop.common.theme.colors;
          let
            bold = "b";
          in
          {
            header = "mb";
            int = "p";
            row_index = "mb";
            list = blue;
            record = blue;
            separator = blue;
          };
        show_banner = false;
        buffer_editor = "nvim";
      };
      shellAliases = {
        nv = "nvim";
        cat = "bat -p";
        ip = "ip -c";
        g = "git status";
        mv = "mv --interactive";
        ll = "lsd -l";
        la = "lsd -a";
        laa = "lsd -all";
        ka = "kakoune";
        em = "emacs -nw";
      };
      extraConfig = ''
        source ~/.config/nix-your-shell.nu
        def deploy [host] {
          let pwd = (pwd); 
          j infra; 
          nixos-rebuild switch --flake .#($host) --target-host $"root@($host)" --impure --log-format internal-json -v o+e>| nom --json 
          | ignore; 
          j $pwd
        }
        def update [host] {
          let pwd = (pwd); 
          j infra; 
          nix flake update;
          deploy $host;
          j $pwd;
        }
        def nre [] { 
          nix repl nixpkgs --show-trace /home/alina/src/flake/
        }
        def l [] {
          let dir = (
          ls 
          | get name 
          | reduce { |it, acc| 
              $acc + "\n" + $it 
            } 
          | ${lib.getExe pkgs.blahaj} 
          | parse "{name}" 
          | merge (ls | reject name));

          $dir | select type | merge ($dir | reject type)
        }
        def mp [] {
          fzf --ansi --no-sort --tac --layout=reverse-list -m --highlight-line --track --bind 'enter:become(
            nu -e "job spawn { mpv {} --no-audio-display }; nu ~/src/dme.nu/mpv.nu"
          )' --preview 'nu trackInfo.nu {}' --tmux --height=~50 --walker-root=/home/alina/music/
        }
        def net [] {
          nmcli -c yes --mode tabular --fields SSID,FREQ,RATE,BARS,SECURITY,ACTIVE --terse d w l 
          | parse '{ssid}:{frequency}:{rate}:{bars}:{security}:{active}' 
          | table --collapse 
          | fzf --header-lines 3 --ansi --track --no-sort --layout=reverse-list --height=100% -m --highlight-line --cycle --bind 'ctrl-r:reload-sync(nu nmcli.nu)' --delimiter │ --bind 'enter:become(nmcli d w c {2})' --header 'Press CTRL-R to reload' -n 2 --history ~/.cache/dme.nu/nmcli.txt;
        }
        def flacInfo [track] {
          metaflac --show-all-tags --with-filename $track 
          | lines
          | split column -n 2 '=' key val
          | each {|e| {($e.key | str downcase): $e.val} }
          | into record 
          | insert size (ls $track).size.0
          | table --collapse
        }
        alias ls = l
      '';
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
  };
}
