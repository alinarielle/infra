{
  perSystem =
    {
      pkgs,
      config,
      inputs',
      lib,
      ...
    }:
    {
      apps.default = {
        type = "app";
        program = lib.getExe (
          pkgs.writeShellScriptBin "deploy" ''
            nu -c "source ${../nu/deploy.nu}; deploy; job spawn {kitty --class dmenu -d ~/infra/ --detach --session --hold --single-instance --instance-group=dmenu --listen-on=unix:@dmenu --override allow_remote_control=socket-only --grab-keyboard --start-as=fullscreen -T dmenu zellij}"
          ''
        );
      };
    };
}
