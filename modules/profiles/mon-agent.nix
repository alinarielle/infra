{config, ...}: with config.l.lib; {
  l.profiles.base.enable = true;
  l.services = enable [
    "victoriametrics"
    "vulnix"
  ];
}
