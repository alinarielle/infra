{ inputs, nixvim, pkgs, lib, ... }: {
    options.l.alina.nvim.enable = lib.mkEnableOption "astro inspired neovim configuration";
    config = mkIf options.l.alina.nvim.enable = true; {
	users.users.alina.packages = with pkgs; [
	    ripgrep
	    lazygit
	    bottom
	    python3
	    nodePackages.nodejs
	    tree-sitter
	];
	fonts.packages = with pkgs; [
	    nerdfonts
	];
	home-manager.users.alina.programs.nixvim = {
	    plugins = {
		lightline = {
		    enable = true;
		    colorscheme = "dark";
		};
	    };
	};
    };

}
