#!/usr/bin/env nu

def meta [path] {
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
