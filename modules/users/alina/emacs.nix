{config, pkgs, ...}: {
  home-manager.users.alina.services.emacs = {
    enable = true;
    package = pkgs.emacs-nox;
    extraOptions = [];
    defaultEditor = true;
    client.arguments = [];
    client.enable = true;
    socketActivation.enable = true;
  };
  home-manager.users.alina.programs.emacs = {
    enable = true;
    package = pkgs.emacs-nox;
    extraPackages = epkgs: [
      org-mode # plain text file life organization
      org-super-agenda
      org-sort-tasks
      org-roam # zettelkasten
      rust-mode
      nix-mode
      markdown-mode
      w3m # terminal browser
      magit # git interface
      magit-delta # git syntax highlighting
      forge
      git-messenger
      git-undo
      evil # vim keybinds
      notmuch # mail client
      devdocs
      lsp-mode # IDE like features
      lsp-ui
      avy # quick jump to text
      web-mode
      restclient # api testing
      projectile
      pass # password manager
      docker
      kubernetes
      hyperbole
      dashboard
      linum-relative
      centaur-tabs
      anzu
      minimap
      ace-link
      general
      try
      vertico
      marginalia
      consult
      powerline
      crux
      highlight-indent-guides
      rainbow-mode
      multiple-cursors
      visual-regexp-steroids
      rainbow-delimiters
      highlight-parentheses
      popup-killring # browse-kill-ring
      drag-stuff
      undo-fu
      yasnippet
      ivy-yasnippet
      evil-nerd-commenter
      auto-complete
      helm-dash
      elpy
      anaconda-mode
      skewer-mode
      impatient-mode
      verb
      which-key
      discover
      deadgrep
      math-preview
      latex-preview-pane
      pdf-tools
      pdf-view-restore
      toc-org
    ];
    extraConfig = ''
      ;;; Org-mode ;;;
      (setq org-id-locations-file (concat user-emacs-directory "/org-id-locations"))
      ;;; Org-roam ;;;
      (setq org-roam-directory "~/zet")
      (org-roam-db-autosync-mode)
    '';
  };
}
