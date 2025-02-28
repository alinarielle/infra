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
    }{
      url = "https://fasterthanli.me/index.xml";
      title = "Fasterthanlime";
      tags = [ "rust" "FOSS" ];
    }{
      url = "https://codeberg.org/irdest/irdest.rss";
      title = "Irdest";
      tags = [ "FOSS" "rust" "networking" "security" "privacy" ];
    }{
      url = "https://codeberg.org/librewolf.rss";
      title = "Librewolf";
      tags = [ "FOSS" "privacy" ];
    }{
      url = "https://www.exploit-db.com/rss.xml";
      title = "ExploitDB";
      tags = [ "FOSS" "security" ];
    }{
      url = "https://cvefeed.io/rssfeed/latest.xml";
      title = "Latest CVE Feed";
      tags = [ "FOSS" "security"];
    }{
      url = "https://cvefeed.io/rssfeed/severity/high.xml";
      title = "Latest High and Critical Severity CVE Feed";
      tags = [ "FOSS" "security"];
    }{
      url = "https://cvefeed.io/rssfeed/newsroom.xml";
      title = "Cyber NewsRoom Vulnerability Feed";
      tags = [ "FOSS" "security"];
    }];
  };
}
