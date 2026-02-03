{
  boot.loader.grub = {
    enable = true;
    device = "/dev/nvme0n1p1";
  };
  boot.loader.efi.canTouchEfiVariables = true;
}
