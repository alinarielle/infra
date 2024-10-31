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
	plugins = {
	    lightline = {
		enable = true;
		colorscheme = "dark";
	    };
	};
    };
}
