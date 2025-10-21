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
      copy_on_select = true;
      mirror_session = false;
      scroll_buffer_size = 1000000000;
      theme = "lucario";
      copy_command = "wl-copy";
      themes.custom.fg = "#ffffff";
      keybinds._props.clear-defaults = true;
      ui = {
        pane_frames.rounded_corners = true;
      };
      auto_layout = true;
      session_serialization = true;
      pane_viewport_serialization = true;
      scrollback_lines_to_serialize = 0;
      disable_session_metadata = false;
      advanced_mouse_actions = true;
      serialization_interval = 30;
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
