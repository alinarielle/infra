{ pkgs, ... }:
{
  home-manager.users.alina.programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
    extraPackages = with pkgs; [
      glow
      bat
      fzf
      ouch
      file
      ffmpeg
      jq
      fd
      rg
    ];
  };
}
