
def l [] {
  let dir = (
  ls 
  | get name 
  | reduce { |it, acc| 
      $acc + "\n" + $it 
    } 
  | ${lib.getExe pkgs.blahaj} 
  | parse "{name}" 
  | merge (ls | reject name));

  $dir | select type | merge ($dir | reject type)
}
