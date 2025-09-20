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
        def deploy [host] {
          let pwd = (pwd); 
          j flake; 
          nixos-rebuild switch --flake .#($host) --target-host $"root@($host)" --impure --log-format internal-json -v 
            o+e>| nom --json 
            | ignore; 
          j $pwd
        }
        def l [] { ls | get name | reduce {|it, acc| $acc + "\n" + $it } | ${lib.getExe pkgs.blahaj} | parse "{name}" | merge (ls | reject name)}
        def nre [] { nix repl nixpkgs --show-trace --expr 'import ~/src/flake {}' }
        source ~/.config/nix-your-shell.nu
        def update [host] {
          let pwd = (pwd); 
          j flake; 
          nix flake update;
          deploy $host;
          j $pwd;
        }
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
