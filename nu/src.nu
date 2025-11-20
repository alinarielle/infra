source /bites/infra/nu/new.nu

def "src branch" [] {
  git branch | parse '{active} {branch}'
}
 def "src status" [] {
  git status --porcelain | parse '{status} {file}'
  
}

def "src meta" [] {
src status | append (src branch)
}

def "src new" [] {
  let repo = new uuid
  let dir = $"/bites/src/($repo)"
  mkdir $dir
  cd $dir
  git init
  cp /bites/pre/* -r .
  let watcher = job spawn { 
    watch -r true . 
    | where operation =~ "Create" 
    | get path 
    | each {|path|
      nom build $"($dir)#default";
      src meta;
      nix fmt;
      git add $path;
      git commit -m $"feat: add ($path | basename)"
    }
  }
  def "src edit" [] {
    glob ./**/*.{nix,md,rs} 
  | each {|file|
      nvim $file;           
      git add $file
    }
  }
  xdg-terminal-exec src edit
}
def "new code" [] {src new}
