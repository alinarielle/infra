def deploy [host] {
  nixos-rebuild switch --flake ~/infra#($host) --target-host $"root@($host)" --impure --log-format internal-json -v o+e>| nom --json 
  | ignore; 
}
