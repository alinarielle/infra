{
  pkgs,
  lib,
  ...
}:
{
  home-manager.users.alina.programs.helix = {
    enable = true;
    package = pkgs.evil-helix;
    themes = {
      ayu_evolve_transparent = {
        "inherits" = "ayu_evolve";
        "ui.background" = { };
      };
    };
    languages = {
      language-server = {
        typos = {
          command = lib.getExe pkgs.typos-lsp;
        };
        terraform-ls = {
          command = "${lib.getExe pkgs.terraform-ls}";
          config = {
            terraform.path = "${lib.getExe pkgs.opentofu}";
          };
        };

        nixd = {
          command = "${lib.getExe pkgs.nixd}";
        };
        rust-analyzer = {
          config.check.command = "clippy";
          command = "${lib.getExe pkgs.rust-analyzer}";
        };
        ansible-language-server = {
          command = "${lib.getExe pkgs.ansible-language-server}";
        };
      };
      language = [
        {
          name = "yaml";
          auto-format = true;
          formatter.command = "${lib.getExe pkgs.yamlfmt}";
          language-servers = [
            "ansible-language-server"
            # "typos"
          ];
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${lib.getExe pkgs.nixfmt-rfc-style}";
          language-servers = [ "nixd" ];
        }
      ];
    };
    settings = {
      keys = {
        normal = {
          K = "hover";
          "C-h" = "jump_view_left";
          "C-l" = "jump_view_right";
          "C-j" = "jump_view_down";
          "C-k" = "jump_view_up";
        };
      };
      theme = "ayu_evolve_transparent";
      editor = {
        rulers = [ 80 ];
        shell = [
          "nu"
          "c"
        ];
        gutters = [
          "diff"
          "diagnostics"
          "line-numbers"
          "spacer"
        ];
        statusline = {
          left = [
            "mode"
            "spinner"
            "diagnostics"
          ];
          center = [
            "file-name"
            "file-modification-indicator"
          ];
          right = [
            "selections"
            "position"
            "position-percentage"
            "file-line-ending"
            "file-type"
            "version-control"
          ];
          separator = "|";
          mode = {
            normal = "NOR";
            insert = "INS";
            select = "SEL";
          };
        };
        bufferline = "multiple";
        auto-save = true;
        color-modes = true;
        cursorline = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "warning";
        };
        indent-guides = {
          render = false;
          rainbow = "dim";
          character = "┆";
        };
        whitespace = {
          render = "all";
          characters = {
            space = "·";
            nbsp = "⍽";
            tab = "→";
            newline = "⏎";
            tabpad = "·";
          };
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
          display-progress-messages = true;
        };
        true-color = true;
        mouse = false;
        soft-wrap = {
          enable = true;
          wrap-indicator = "";
        };
      };
    };
  };
}
