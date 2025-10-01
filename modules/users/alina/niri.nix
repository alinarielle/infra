{ inputs, ... }:
{
  imports = [ inputs.niri.nixosModules.niri ];
  services.displayManager.defaultSession = "niri";
  programs.niri = {
    enable = true;
    settings = {
      workspaces = let
        main = "eDP-1";
        secondary = "HDMI-A-1";
      in {

      };
    };
  };
}
