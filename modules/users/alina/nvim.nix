{ inputs, pkgs, lib, config, ... }: {
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
      settings = {
        transparent = true;
      };
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
      render-markdown.enable = true;
      lightline = {
        enable = true;
      };
      treesitter.enable = true;
      lsp.enable = true;
      gx = {
        enable = true;

      };
      neorg = {
        enable = true;
        settings = {
          load = {
            "core.concealer" = {
              config = {
                icon_preset = "varied";
              };
            };
            "core.defaults" = {
              __empty = null;
            };
            "core.dirman" = {
              config = {
                workspaces = {
                };
              };
            };
          };
        };

      };
      typst-preview.enable = true;
      actions-preview.enable = true;
      aerial.enable = true;
    };
  };
}
