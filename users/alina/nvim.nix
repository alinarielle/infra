{ ... }: {
    imports = [ inputs.nixvim.homeManagerModules.nixvim ];
    home-manager.users.alina.programs.nixvim = {
	enable = true;
	options = {
	    number = true;
	    relativenumber = true;

	    shiftwidth = 4;
	};
	plugins = {
	    lsp.enable = true;
	    telescope.enable = true;
	    treesitter.enable = true;
	};
    };    
}
