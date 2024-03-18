{ inputs, nixvim, pkgs, ... }: {
    
home-manager.users.alina = {
    imports = [ inputs.nixvim.homeManagerModules.nixvim ];
    programs.nixvim = {
	enable = true;
	options = {
	    number = true;
	    relativenumber = true;
	    shiftwidth = 4;
	};
	plugins = {
	    lsp.enable = true;
	};
	extraPlugins = with pkgs.vimPlugins; [
	    nvim-treesitter
	    telescope-nvim
	    lightline-vim
	];
    }; 
};
}
