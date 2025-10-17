def update [host] {
  let pwd = (pwd); 
  j infra; 
  nix flake update;
  deploy;
  j $pwd;
}
