{
  programs.proxychains = {
    enable = true;
    proxies.tor = {
      enable = true;
      type = "socks5";
      host = "127.0.0.1";
      port = 9050;
    };
  };
}
