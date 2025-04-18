{config, ...}: with config.l.lib; {
  l.profiles.base.enable = true;
  l.services = enable [
    "grafana"
    "librenms"
    "alertmanager"
    "victoriametrics"
    "bird-lg"
    "elastic-search"
  ];
}
