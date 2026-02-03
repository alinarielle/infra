def deploy [] {
  let host = "arielle";
  nixos-rebuild switch --flake . --target-host root@localhost --accept-flake-config --impure --log-format internal-json -v o+e>| nom --json
}
