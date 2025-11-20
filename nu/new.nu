def "new uuid" [] {
  uuidgen --time-v7
}
def "new typst" [] {
  
}
def "new torrent" [] {
  
}
def "new angel" [] {
  
}
def "new tear" [] {
  
}
def "new rust" [] {
  
}
def "new key" [] {
  ssh-keygen -t ed25519 -a 32 -f $"/bites/keys/(new uuid)"
}
def "new calendar" [] {
  
}
def "new norg" [] {
  
}
def "new host" [] {
  
}
def "new blob" [] {
  #TODO: collection of symlinks under /bites/blob according to one nushell glob
}
def "blob meta" [path] {
  let dir = (pwd);
  j $path;
  let index = tree -J 
  | from json
  | get 0
  
  let count = tree -J
  | from json
  | get 1.files

  let result = [[count index ];[$count $index]] 
  
  $result | to nuon o>> .meta.nuon

  open .meta.nuon | each  {|it| $it | last}

  j $dir
}
