{ inputs, pkgs, lib, ... }: {
  imports = [ inputs.nixvim.nixosModules.nixvim ];
  users.users.alina.packages = with pkgs; [
    ripgrep
    lazygit
    bottom
    python3
    nodePackages.nodejs
    tree-sitter
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorschemes.cyberdream = {
      enable = true;
      settings.transparent = true;
    };
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      expandtab = true;
      tabstop = 2;
      softtabstop = 2;
    };
    plugins = {
      lightline = {
        enable = true;
      };
      lsp.enable = true;
      #actions-preview.enable = true;
      #aerial.enable = true;
    };
  };
}
