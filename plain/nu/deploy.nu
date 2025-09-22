def deploy [host] {
  let pwd = (pwd); 
  j infra; 
  nixos-rebuild switch --flake .#($host) --target-host $"root@($host)" --impure --log-format internal-json -v o+e>| nom --json 
  | ignore; 
  j $pwd
}
