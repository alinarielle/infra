{inputs, pkgs, self, lib, ...}: {
    imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
} // self.lib.modules.mkLocalModule ./lanzaboote.nix "lanzaboote config" {
    environment.systemPackages = [pkgs.sbctl];
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.lanzaboote = {
	enable = true;
	pkiBundle = "/etc/secureboot";
    };
}
