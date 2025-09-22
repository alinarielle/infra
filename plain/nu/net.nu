#!/bin/env nu

def net [] {
  nmcli -c yes --mode tabular --fields SSID,FREQ,RATE,BARS,SECURITY,ACTIVE --terse d w l 
  | parse '{ssid}:{frequency}:{rate}:{bars}:{security}:{active}' 
  | table --collapse 
  | fzf --header-lines 3 --ansi --track --no-sort --layout=reverse-list --height=100% -m --highlight-line --cycle --bind 'ctrl-r:reload-sync(net)' --delimiter │ --bind 'enter:become(nmcli d w c {2})' --header 'Press CTRL-R to reload' -n 2 --history ~/.cache/dme.nu/nmcli.txt;
}
