def deploy [] {
  let host = (hostname);
  nixos-rebuild switch --flake ~/infra --target-host $"root@($host)" --impure --log-format internal-json -v o+e>| nom --json; 
}
