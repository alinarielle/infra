def update [host] {
  let pwd = (pwd); 
  j infra; 
  nix flake update;
  deploy $host;
  j $pwd;
}
