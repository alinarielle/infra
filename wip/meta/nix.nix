{inputs, pkgs, ...}: {
    imports = [ inputs.lix-module.nixosModules.default ];
    nix = {
	allowedUsers = [ "@wheel" "root" ];
	settings = {
	   experimental-features = [ "nix-command" "flakes" ];
	   trusted-users = [ "@wheel" "root" ];
	};
	config = {
	   auto-optimise-store = true;
	};
	gc = {
	   automatic = true;
	   options = "--delete-older-than 7d";
	};
	package = pkgs.lix;
   };
}
