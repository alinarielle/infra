{name, pkgs, lib, ...}: {
  services.kanidm = {
    enablePAM = true;
    unixSettings = {
      version = "2";
      default_shell = lib.getExe pkgs.zsh;
      pam_allowed_login_groups = [ "${name}-access" ];
    };
  };
}
