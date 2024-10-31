{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerdfonts
  ]; #todo exorcist fonts
}
