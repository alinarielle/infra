{
  home-manager.users.alina.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      global.hide_env_diff = true;
      enableNushellIntegration = true;
    };
  };
}
