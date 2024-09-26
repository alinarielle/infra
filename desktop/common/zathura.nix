{lib, config, ...}: config.l.lib.mkLocalModule ./zathura.nix "pdf reader" {
    home-manager.users.alina.programs.zathura = {
	enable = true;
	extraConfig = ''
	    set recolor "true"
	    set default-bg rgba(46,52,64,0.65)
	    set recolor-lightcolor rgba(0,0,0,0)
	    set adjust-open "width"
	    set guioptions none
	    set adjust-open "best-fit"
	    set scroll-page-aware "true"
	    set scroll-full-overlap 0.01
	    set font "Inter 15"
	'';
    };
}
