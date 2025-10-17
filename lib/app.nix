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
          pkgs.writeShellScriptBin "deploy" (builtins.readFile "${inputs'.nu}/deploy.nu")
        );
      };
    };
}
