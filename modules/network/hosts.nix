{ name, ... }:
{
  networking.hosts = {
    "127.0.0.1" = [
      "${name}.nodes.alina.cx"
      name
    ];
  };
}
