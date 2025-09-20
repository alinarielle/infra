{ inputs, ... }:
{
  l.network.nginx.vhosts."alina.cx" = {
    root = "${inputs.homepage}";
  };
}
