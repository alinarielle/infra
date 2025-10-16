{ pkgs, ... }:
{
  home-manager.users.alina.programs.kakoune = {
    enable = true;
    package = pkgs.kakoune-unwrapped;
    plugins = with pkgs.kakounePlugins; [
      kak-fzf
    ];
    config = {

    };
  };
}
