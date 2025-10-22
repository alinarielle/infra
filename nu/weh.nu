def weh [unit] {
sudo systemctl cat $unit | rg ExecStart | str replace 'ExecStart=' '' | wl-copy
}
