{inputs, pkgs, config, lib, ...}: {
    imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
} // config.l.lib.mkLocalModule ./lanzaboote.nix "lanzaboote config" {
    environment.systemPackages = [pkgs.sbctl];
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
	enable = true;
	pkiBundle = "/etc/secureboot";
    };
}
