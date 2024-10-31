{inputs, pkgs, ...}: {
    imports = [ inputs.lix-module.nixosModules.default ];
    nix = {
	allowedUsers = [ "@wheel" "root" ];
	settings = {
	   experimental-features = [ "nix-command" "flakes" ];
	   trusted-users = [ "@wheel" "root" ];
	};
	optimise = {
	    automatic = true;
	    dates = ["03:45"];
	};
	gc = {
	   automatic = true;
	   options = "--delete-older-than 7d";
	};
  };
  nixpkgs.config = {
    permittedInsecurePackages = [
      "olm-3.2.16"
    ];
    allowUnfree = true;
  };
}
