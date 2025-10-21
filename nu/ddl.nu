def ddl [links] { 
  let downloads = $links 
  | each {|it| job spawn {dl $it --hls-use-mpegts -N 3 -t mkv}}
}
