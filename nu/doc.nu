def doc [name] {
  let oldDir = (pwd)
  let repo = $"/home/alina/src/docs/($name)"
  mkdir $repo
  j $repo
  git init
  touch doc.typ
  job spawn { watch -r true . | get path | path expand | each {|it|let isSource = $it | str ends-with ".typ"; if $isSource { typst c $it } else  { let isDoc = $it | str ends-with ".pdf"; if $isDoc {cp $it $"/home/alina/blob/documents/(sha256sum $it | split words | first).pdf"; xdg-open $it } else {echo "processing..."} }}}
  nvim doc.typ
  git add -A
  git commit -m "doc: ($name) in typst"
  j $oldDir
}
