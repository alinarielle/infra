{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  hmLib = config.home-manager.users.alina.lib;
in
{
  users.users.alina.packages = with pkgs; [
    ripgrep
    lazygit
    bottom
    python3
    nodePackages.nodejs
    tree-sitter
    neovim
  ];

  home-manager.users.alina.xdg.configFile = {
    "nvim".source = hmLib.file.mkOutOfStoreSymlink "/bites/src/nvim";
  };
}
