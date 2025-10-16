{ name, inputs, ... }:
{
  sops.defaultSopsFile = "${inputs.sops}/global.yaml";
}
