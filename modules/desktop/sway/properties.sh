#!/run/current-system/sw/bin/bash
set -euo pipefail
CRITERIA=('app_id' 'class' 'con_id' 'con_mark' 'floating' 'id' 'instance' 'pid' 'shell' 'tiling' 'title' 'urgent' 'window_role' 'window_type' 'workspace'
INFO=$(swaymsg -t get_tree | \
  jq -r '..|try select(.focused == true)|with_entries(select([.key] | inside(["app_id"])))')

notify-send \
  -a "Window Properties" \
  -w \
  -u low \
  "Window Properties:" \
  ${INFO//$'\n'/\\n}
