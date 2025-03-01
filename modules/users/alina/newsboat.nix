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
    }{
      url = "https://lena.nihil.gay/blog/rss.xml";
      title = "Lena's blog (@lena@treehouse.systems)";
    }{
      url = "https://www.girlonthenet.com/feed/";
      title = "Girl on the Net";
    }{
      url = "https://servo.org/blog/feed.xml";
      title = "Servo";
    }{
      url = "https://www.haskellforall.com/feeds/posts/default";
      title = "Haskell for all";
    }{
      url = "https://env.fail/blog.rss";
      title = "env.fail";
    }{
      url = "https://marcan.st/posts/index.xml";
      title = "Marcan";
    }{
      url = "https://maia.crimew.gay/feed.xml";
      title = "Maia Crimew";
    }{
      url = "https://drewdevault.com/blog/index.xml";
      title = "Drew Devault";
    }{
      url = "https://emersion.fr/blog/atom.xml";
      title = "Emersion";
    }{
      url = "https://bitfehler.srht.site/index.xml";
      title = "blogfehler!";
    }{
      url = "https://rosenzweig.io/feed.xml";
      title = "On Life and Lisp";
    }{
      url = "https://liveoverflow.com/rss/";
      title = "LiveOverflow";
    }{
      url = "https://nonpolynomial.com/feed/";
      title = "Nonpolynomial";
    }{
      url = "https://cadence.moe/blog/rss.xml?limit=30";
      title = "cadence";
    }{
      url = "https://heckscaper.com/rss.xml";
      title = "heckscaper";
    }{
      url = "https://lethalbit.net/atom.xml";
      title = "Aki LethalBit";
    }{
      url = "https://foxgirls.gay/index.xml";
      title = "Luna Foxgirl's Blog";
    }{
      url = "https://www.jeffgeerling.com/blog.xml";
      title = "Jeff Geerling's Blog";
    }{
      url = "https://asahilinux.org/blog/index.xml";
      title = "Blog on Asahi Linux";
    }{
      url = "https://www.tomscott.com/updates.xml";
      title = "Tom Scott's Weekly Newsletter";
    }{
      url = "https://foone.wordpress.com/atom.xml";
      title = "Fooone Turing's blog":
    }{
      url = "https://blog.ihaveahax.net/atom.xml";
      title = "ihaveahax's thing";
    }];
  };
}
