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
          with config.l.users.alina.theme.colors;
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
      };
      extraConfig = ''
        source ~/.config/nix-your-shell.nu
        source ~/src/infra/plain/nu/''
      + lib.concatMapAttrsStringSep "; source ~/src/infra/plain/nu/" (key: val: key) (
        builtins.readDir ../../../plain/nu
      );
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
