def archive [file] { 
  let blob = [
    [
      datetime 
      uuid 
      sha256 
      type 
      encoding 
      name 
      type 
      target 
      readonly 
      mode 
      num_links 
      inode 
      user 
      group 
      size 
      created 
      accessed 
      modified
    ]; [
    (date now) 
    (uuidgen) 
    (open $file | hash sha256) 
    (file $file --mime-type --uncompress --raw) 
    (file $file --mime-encoding --uncompress --raw) 
    (...(ls $file -all))
  ]] | to nuon; 

  rclone move $file $"tigris_crypt:($blob)" --delete-empty-src-dirs --no-traverse --dry-run --immutable --absolute --csv --links --order-by 'size,descending' --no-check-dst --fast-list --no-update-modtime 
  | from csv

  $blob
}
