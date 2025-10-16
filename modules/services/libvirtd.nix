{
  virtualisation.libvirtd = {
    enable = true;
    nss.enable = true;
  };
  users.users.alina.groups = [ "libvirtd" ];
}
