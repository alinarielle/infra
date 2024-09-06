{self, lib, ...}: self.lib.modules.mkLocalModule ./systemd-boot.nix "systemd-boot" {
    boot.loader = lib.mkDefault {
	systemd-boot.enable = true;
	efi.canTouchEfiVariables = true;
    };
} # assumes system supports EFI, TODO add check if EFI and add legacy boot option TODO customize boot screen (splash, entries, theme, etc..)
