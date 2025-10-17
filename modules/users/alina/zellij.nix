{
  home-manager.users.alina.programs.zellij = {
    attachExistingSession = true;
    exitShellOnExit = true;
    extraConfig = ''
      keybinds {
        // keybinds are divided into modes
        normal {
            // bind instructions can include one or more keys (both keys will be bound separately)
            // bind keys can include one or more actions (all actions will be performed with no sequential guarantees)
            bind "Ctrl g" { SwitchToMode "locked"; }
            bind "Ctrl p" { SwitchToMode "pane"; }
            bind "Alt n" { NewPane; }
            bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
        }
        pane {
            bind "h" "Left" { MoveFocus "Left"; }
            bind "l" "Right" { MoveFocus "Right"; }
            bind "j" "Down" { MoveFocus "Down"; }
            bind "k" "Up" { MoveFocus "Up"; }
            bind "p" { SwitchFocus; }
        }
        locked {
            bind "Ctrl g" { SwitchToMode "normal"; }
        }
      }
    '';
    settings = {
      theme = "custom";
      themes.custom.fg = "#ffffff";
      keybinds._props.clear-defaults = true;
      keybinds.pane._children = [
        {
          bind = {
            _args = [ "e" ];
            _children = [
              { TogglePaneEmbedOrFloating = { }; }
              { SwitchToMode._args = [ "locked" ]; }
            ];
          };
        }
        {
          bind = {
            _args = [ "left" ];
            MoveFocus = [ "left" ];
          };
        }
      ];
    };
  };
}
