{pkgs, ...}: {
  services.emacs = {
    enable = true;
  };
  environment.systemPackages = [(pkgs.emacsWithPackagesFromUsePackage {
    defaultInitFile = true;
    alwaysEnsure = true;
    alwaysTangle = false;
    extraEmacsPackages = epkgs: with epkgs; [
      vterm
      #org-mode consult powerline try ace-link evil git-undo
      #org-roam crux highlight-ident-guides notmuch
      #org-sort-tasks rainbow-mode minimap devdocs
      #org-super-agenda multiple-cursors lsp-mode git-messenger
      #rust-mode visual-regexp-steroids avy lsp-ui
      #nix-mode rainbow-delimiters anzu verb web-mode
      #markdown-mode highlight-parentheses restclient
      #w3m popup-killring drag-stuff pass projectile
      #magit marginalia vertico kubernetes docker
      #magit-delta centaur-tabs hyperbole
      #forge linum-relative dashboard direnv-mode
    ];
    config = pkgs.writeTextFile { 
      name = "init.el";
      text = ''
	(require 'package)
	(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
	(package-initialize)

	(require 'use-package)
	(require 'use-package-ensure)
	(setq use-package-always-ensure t)

	(unless (package-installed-p 'use-package)
	  (package-refresh-contents)
	  (package-install 'use-package))
	(eval-and-compile
	  (setq use-package-always-ensure t
		use-package-expand-minimally t))
	
	(use-package direnv
	  :init
	  (direnv-mode))

	
	;;; Org-mode ;;;
	(setq org-id-locations-file (concat user-emacs-directory "/org-id-locations"))
	;;; Org-roam ;;;
	(setq org-roam-directory "~/zet")
	(org-roam-db-autosync-mode)
      '';
    };
  })];
}
