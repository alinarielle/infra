xdg-open (fzf --preview "bat -f {} -p" --tail 100000 --scheme=path --layout reverse --preview-window bottom --walker-root ~/src/ --walker file --walker-skip .git,node_modules,result,/nix/store)
