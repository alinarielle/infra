{config, pkgs, ...}: {
  home-manager.users.alina.programs.emacs = {
    enable = true;
    package = pkgs.emacs-unstable-nox;
    defaultEditor = true;
  };
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    }))
  ];
  services.emacs = {
    enable = true;
    package = pkgs.emacs-unstable-nox;
  };
  environment.systemPackages = let
    emacsConfigFile = pkgs.writeTextFile {
      name = "config.el";
      text = ''
        ;;; Org-mode ;;;
	(setq org-id-locations-file (concat user-emacs-directory "/org-id-locations"))
	;;; Org-roam ;;;
	(setq org-roam-directory "~/zet")
	(org-roam-db-autosync-mode)
      '';
    };
  in 
  [
    (pkgs.emacsWithPackagesFromUsePackage {
      config = emacsConfigFile;
      defaultInitFile = true;
      alwaysEnsure = false;
      extraEmacsPackages = epkgs: with epkgs; [
	cask
	vterm 
	org-mode 
	org-roam
	execline
	rust-mode
	nix-mode
	markdown-mode
      ];
    })
  ];
}

