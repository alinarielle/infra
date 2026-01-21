def anywhere [] {
nix run github:nix-community/nixos-anywhere -- --flake .#de1 --target-host root@de1.net.alina.dog --generate-hardware-config nixos-generate-config ./hosts/de1/hardware-configuration.nix --build-on remote
}
