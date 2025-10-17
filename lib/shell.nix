{
  perSystem =
    {
      pkgs,
      config,
      inputs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        strictDeps = true;
        buildInputs = with pkgs; [ zellij ];
        shellHook = ''
          zellij
        '';
      };
    };
}
