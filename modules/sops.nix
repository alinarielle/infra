{ name, ... }:
{
  sops.defaultSopsFile = "${../secrets}/${name}/secrets.yaml";
}
