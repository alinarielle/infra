{ inputs, ... }:
{
  imports = [ inputs.niri.nixosModules.niri ];
  services.displayManager.defaultSession = "niri";
  home-manager.users.alina = {
    imports = [
      inputs.niri.homeModules.config
    ];
    programs.niri = {
      enable = true;
      settings = { };
    };
  };
}
