{
  lib,
  config,
  ...
}:
{
  h.spicetify.ini = {
    Setting.current_theme = "";
    inject_css = 1;
    overwrite_assets = 1;
    spotify_launch_flags = lib.cli.toGNUCommandLineShell { } {
      username = "hi@alina.cx";
      password = config.sops.secrets.spotifyPass.path; # TODO: desktop systemd service abstraction for secrets
    };
  };
}
