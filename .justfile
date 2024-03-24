build-iso:
    nix build .#nixosConfigurations.iso.config.system.build.isoImage
    ls ./result/iso
update:
    nix flake update
