{pkgs, ...}: {
  home-manager.users.alina.programs.newsboat = {
    enable = true;
    autoReload = true;
    browser = "${pkgs.xdg-utils}/bin/xdg-open";
    urls = [{
      url = "https://soatok.blog/rss";
      title = "Soatok";
      tags = [ "cryptography" "security" "linux" "FOSS" ];
    }{
      url = "https://xeiaso.net/blog.rss";
      title = "Xe Iaso";
      tags = [ "NixOS" "tailscale" "FOSS" "linux" "security" "networking" "cloud" ];
    }{
      url = "https://xaselgio.net/index.xml";
      title = "Indigo's den";
      tags = [ "linux" "FOSS" ];
    }{
      url = "https://www.notrace.how/rss.xml";
      title = "NoTrace.How";
      tags  = ["privacy" "security" "FOSS" "linux" "networking"];
    }{
      url = "https://blog.cloudflare.com/rss";
      title = "Cloudflare";
      tags = [ "cloud" "linux" "FOSS" "networking" "security"];
    }{
      url = "https://kamila.pet/rss.xml";
      title = "MarkAssPandi's blog";
      tags = [ "security" "linux" ];
    }{
      url = "https://www.patrick-breyer.de/?feed=rss2";
      title = "Patrick Breyer";
      tags = [ "privacy" "FOSS" "politics" ];
    }{
      url = "https://mullvad.net/en/blog/feed/atom";
      title = "Mullvad";
      tags = [ "networking" "privacy" "FOSS" ];
    }];
  };
}
