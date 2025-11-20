def doc [name] {
  let oldDir = (pwd)
  let repo = $"/home/alina/src/docs/($name)"
  mkdir $repo
  j $repo
  git init
  touch doc.typ
  job spawn { watch -r true . | get path | each {|path|nix build}}
  nvim doc.typ
  git add -A
  git commit -m "doc: ($name) in typst"
  j $oldDir
}
