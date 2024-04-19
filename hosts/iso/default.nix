{inputs,...}: 
{
    imports = [
	../../profiles/desktop
	"${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
	"${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ];
    services.qemuGuest.enable = true;
    networking.hostName = "iso";
    nixpkgs.config.allowUnfree = true;
    system.stateVersion = "24.05";
    isoImage.squashfsCompression = "gzip -Xcompression-level 1";
    deployment = {
	targetUser = "alina";
	targetHost = "installer.infra.alina.cx";
	tags = [ "tags" "infra" ];
    };
}
