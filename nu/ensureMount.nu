def ensureMount [] {
  let mount = mount 
  | parse '{name} on {mountPoint} type {type} ({mountOptions})' 
  | where mountPoint == "/crypt"; 

  match $mount { 
    [[name, mountPoint, type, mountOptions]; [
      "tigris_crypt:", 
      /crypt, 
      "fuse.rclone", 
      "rw,nosuid,nodev,relatime,user_id=1000,group_id=100"
    ]] => 'S3 bucket mounted correctly', 

    _ => {
      rclone --config /bites/rclone.conf mount tigris_crypt: /crypt --daemon
    } 
  } 
}
