{ inputs, pkgs, ... }: {
    imports = [ inputs.nixvim.nixosModules.nixvim ];
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
    programs.nixvim = {
    	enable = true;
	colorschemes.catppuccin.enable = true;
	opts = {
	    number = true;
	    relativenumber = true;
	    shiftwidth = 4;
	};
	plugins = {
	    lightline = {
		enable = true;
	    };
	    lsp.enable = true;
	};
    };
}
