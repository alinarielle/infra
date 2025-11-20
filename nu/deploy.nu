def deploy [] {
  let host = (hostname);
  nixos-rebuild switch --flake /bites/infra --target-host root@localhost --accept-flake-config --impure --log-format internal-json -v o+e>| nom --json
}
