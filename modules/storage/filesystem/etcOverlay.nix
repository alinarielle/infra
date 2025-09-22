{
  system.etc.overlay = {
    enable = true;
    mutable = false;
  };
  boot.initrd.systemd.enable = true;
  systemd.sysusers.enable = true;
}
