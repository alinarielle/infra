build-iso:
    mkdir -p iso
    nix build .#nixosConfigurations.iso.config.system.build.isoImage
    ls ./result/iso
