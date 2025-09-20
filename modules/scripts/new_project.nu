def main [dir: path] {
  mkdir -p ~/src/( $dir ); cd ~/src/( $dir ); git init
  nix flake init -t (fzf )
  mkdir -p ./org; nv ./org/idea.norg
  git add -A
  git commit -m "init"
} 
