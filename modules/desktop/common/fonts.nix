{pkgs, lib, ...}: {
  fonts.packages = with pkgs.nerd-fonts; [
    monaspace
    ubuntu
    ubuntu-mono
    ubuntu-sans
    zed-mono
    fira-mono
    jetbrains-mono
  ];
}
