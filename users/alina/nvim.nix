{ inputs, pkgs, lib, config, ... }: {
    imports = [ inputs.nixvim.homeManagerModules.nixvim ];
} // config.l.lib.mkLocalModule ./nvim.nix "nvim config" {
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
}
