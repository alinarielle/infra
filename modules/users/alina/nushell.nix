{
  pkgs,
  lib,
  config,
  name,
  ...
}:
{
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
          with config.l.users.alina.theme.colors;
          let
            bold = "b";
          in
          {
            # header = "mb";
            # int = "p";
            # row_index = "gb";
            # list = primary;
            # record = primary;
            # separator = primary;
            # string = primary;
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
      };
      extraConfig = with pkgs.nushellPlugins; ''
                plugin add ${lib.getExe gstat}
                plugin add ${lib.getExe polars}
                plugin add ${lib.getExe query}
                source ~/.config/nix-your-shell.nu
                source ${lib.concatMapAttrsStringSep " " (key: val: key) (builtins.readDir ${../../../nu})}

                j /bites
        	'';
    };
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
