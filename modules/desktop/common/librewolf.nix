{lib, config, name, ...}: {
  home-manager.users.alina = {
    programs.librewolf = {
      enable = true;
      settings = {
        "identity.fxaccounts.enable" = true;
	"identity.fxaccounts.enabled" = true;
	"identity.fxaccounts.device.name" = "alina's librewolf on " + name;
	#"identity.fxaccounts.autoconfig.uri" = "https://ffsync.alina.cx/";
	#"identity.fxaccounts.remote.root = "https://ffsync.alina.cx/";
	#"identity.fxaccounts.auth.uri" = "https://api.ffsync.alina.cx/v1";

	"browser.tabs.insertAfterCurrent" = true;
	"browser.bookmarks.editDialog.showForNewBookmarks" = false;
	"browser.search.suggest.enabled" = true;
	"pdfjs.viewerCssTheme" = 2;
	"network.http.referer.XOriginPolicy" = 2;
	"privacy.clearOnShutdown.history" = false;
	"privacy.clearOnShutdown.downloads" = false;
	"security.OCSP.require" = false;
	"privacy.clearOnShutdown.cookies" = true;
	"svg.context-properties.content.enabled" = true;

	# force enable GPU acceleration
	"gfx.webrender.all" = true;

	# Hide the "sharing indicator", it's especially annoying
	# with tiling WMs on wayland
	"privacy.webrtc.legacyGlobalIndicator" = false;
      };
    };
  };
  environment.etc."librewolf/policies.json" = {
    text = let
      extension = shortId: uuid: {
	name = uuid;
	value = {
	  install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
	  installation_mode = "normal_installed";
	};
      }; 
    in builtins.toJSON { 
      policies = {
	# To add additional extensions, find it on addons.mozilla.org, find
	# the short ID in the url 
	# (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
    	# then to find the extension UUID, go to 
	# about:debugging#/runtime/this-firefox in your browser and grab the
	# extension ID, not the Internal UUID
	ExtensionSettings = lib.listToAttrs [
	  (extension "simple-tab-groups" "simple-tab-groups@drive4ik")
	  (extension "ublock-origin" "uBlock0@raymondhill.net")
	  (extension "umatrix" "uMatrix@raymondhill.net")
	  (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
	  (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
	  (extension "bonjourr-startpage" "{4f391a9e-8717-4ba6-a5b1-488a34931fcb}")
	  (extension "canvasblocker" "CanvasBlocker@kkapsner.de")
	  (extension "consent-o-matic" "gdpr@cavi.au.dk")
	  (extension "deadname-remover" "deadname-remover@willhaycode.com")
	  (extension "debrid-link-plugin" "jid1-6kU7yIbrTcZvJg@jetpack")
	  (extension "downthemall" "{DDC359D1-844A-42a7-9AA1-88A850A938A8}")
	  (extension "duckduckgo-for-firefox" "ddg@search.mozilla.org")
	  (extension "fastforwardteam" "addon@fastforward.team")
	  (extension "firefox-translations" "firefox-translations-addon@mozilla.org")
	  (extension "localcdn-fork-of-decentraleyes" "{b86e4813-687a-43e6-ab65-0bde4ab75758}")
	  (extension "libredirect" "7esoorv3@alefvanoon.anonaddy.me")
	  (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
	  (extension "search_by_image" "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}")
	  (extension "sixindicator" "{8c9cad02-c069-4e93-909d-d874da819c49}")
	  (extension "torproject-snowflake" "{b11bea1f-a888-4332-8d8a-cec2be7d24b9}")
	  (extension "sponsorblock" "sponsorBlocker@ajay.app")
	  (extension "styl-us" "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}")
	  (extension "temp-mail" "{2d97895d-fcd3-41ab-82e6-6a1d4d2243f6}")
	  (extension "terms-of-service-didnt-read" "jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack")
          (extension "user-agent-string-switcher" "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}")
	  (extension "darkreader" "addon@darkreader.org")
        ];
	SearchEngines = {
	  PreventInstalls = false;
	  Remove = [
	    "Google" "Bing" "Amazon.com" "eBay" "Twitter"
	    "MetaGer" "StartPage" "4get.ca (captcha)" "DuckDuckGo Lite"
	  ];
	  Default = "DuckDuckGo";
	  Add = [{
	    Name = "PsychonautWiki";
	    Description = "search for anything psychoactive";
	    Alias = "psy";
	    Method = "GET";
	    URLTemplate = "https://psychonautwiki.org/w/index.php?title=Special:Search&search={searchTerms}";
	    IconURL = "https://psychonautwiki.org/favicon.org";
	  }
	  {
	    Name = "MELPA";
	    Description = "Milkypostman’s Emacs Lisp Package Archive";
	    Alias = "melpa";
	    Method = "GET";
	    URLTemplate = "https://melpa.org/#/?q={searchTerms}";
	    IconURL = "https://melpa.org/favicon.ico";
	  }
	  {
	    Name = "NixOS packages";
	    Description = "the largest software collection in the world";
	    Alias = "nixp";
	    Method = "GET";
	    URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
	    IconURL = "https://search.nixos.org/favicon.ico";
	  }
	  {
	    Name = "NixOS options";
	    Description = "search NixOS options by name or description";
	    Alias = "nixon";
	    Method = "GET";
	    URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
	    IconURL = "https://search.nixos.org/favicon.org";
	  }
	  {
	    Name = "ArchWiki";
	    Description = "i use arch btw";
	    Alias = "aw";
	    Method = "GET";
	    URLTemplate = "https://wiki.archlinux.org/index.php?title=Special:Search&search={searchTerms}";
	    IconURL = "https://wiki.archlinux.org/favicon.ico";
	  }
	  {
	    Name = "YouTube";
	    Description = "Search for videos on YouTube.";
	    Alias = "y";
	    Method = "GET";
	    URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}&page={startPage?}&utm_source=opensearch";
	    IconURL = "https://youtube.com/favicon.ico";
	  }
	  {
	    Name = "YouTube Music";
	    Description = "search for songs on YouTube Music";
	    Alias = "ym";
	    Method = "GET";
	    URLTemplate = "https://music.youtube.com/search?q={searchTerms}&utm_source=opensearch";
	    IconURL = "https://music.youtube.com/favicon.ico";
	  }
	  {
	    Name = "GitHub";
	    description = "Search GitHub";
	    Alias = "gh";
	    Method = "GET";
	    URLTemplate = "https://github.com/search?q={searchTerms}&ref=opensearch";
	    IconURL = "https://github.com/favicon.ico";
	  }
	  {
	    Name = "Noogle";
	    Description = "Search for nix functions by name.";
	    Alias = "noo";
	    Method = "GET";
	    URLTemplate = "https://noogle.dev/q?term={searchTerms}";
	    IconURL = "https://noogle.dev/favicon.ico";
 	  }
	  {
	    Name = "Home Manager Options Search";
	    Description = "Search for home manager options by name.";
	    Alias = "nixo";
	    Method = "GET";
	    URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}";
	    IconURL = "https://home-manager-options.extranix.com/favicon.ico";
	  }
	  {
	    Name = "crates.io";
	    Description = "Search for crates in the official Rust package registry.";
	    Alias = "crate";
	    Method = "GET";
	    URLTemplate = "https://crates.io/search?q={searchTerms}";
	    IconURL = "https://crates.io/favicon.ico";
	  }
	  {
	    Name = "Wikipedia";
	    Alias = "wk";
	    Method = "GET";
	    URLTemplate = "https://en.wikipedia.org/wiki/Special:Search?search={searchTerms}&sourceid=Mozilla-search";
	    Description = "one search away from the knowledge of the world!";
	  }];
	};
      };
    };
  };
}
