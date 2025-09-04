{pkgs, lib, inputs, ...}: let
  git = lib.getExe pkgs.git;
  nix  = lib.getExe pkgs.lix;
  fzf = lib.getExe pkgs.fzf;
  nv = lib.getExe pkgs.neovim;
  inherit (inputs) templates;
in {
  l.scripts.pkgs.newProject = pkgs.writeShellScriptBin "newProject.nu" ''
    #!/usr/bin/env nu
    def main [dir: path] {
      mkdir -p ~/src/( $dir ); cd ~/src/( $dir ); ${git} init
      cp ${templates}/(${fzf} --walker-root ${templates}) .
      echo "use flake" o> .envrc
      mkdir -p ./org; ${nv} ./org/idea.norg
      ${git} add -A
      ${git} commit -m "init"
      ${git} status
    }
  '';
}
