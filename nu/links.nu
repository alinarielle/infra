def links [url] {
  http get $url 
  | query webpage-info 
  | get links
}
