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
            nu -c "source ${../nu/deploy.nu}; deploy"
          ''
        );
      };
    };
}
