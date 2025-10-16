{
  perSystem = {pkgs, config, inputs, ...}: {
    devShells.default = pkgs.mkShell {
      strictDeps = true;
      buildInputs = [];
    };
  };
}
