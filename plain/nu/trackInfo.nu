def trackInfo [track] { metaflac --show-all-tags --with-filename $track | lines
| split column -n 2 '=' key val
| each {|e| {($e.key | str downcase): $e.val} }
| into record 
| insert size (ls $track).size.0
| table --collapse 
}
def main [item] { trackInfo $item }

